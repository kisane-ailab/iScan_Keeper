import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_quill/markdown_quill.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/storage/attachment_storage_service.dart';

/// 대응 완료 다이얼로그 결과
class ResponseCompleteResult {
  final String markdown;
  final Map<String, dynamic> content;
  final List<AttachmentInfo> attachments;

  ResponseCompleteResult({
    required this.markdown,
    required this.content,
    required this.attachments,
  });
}

/// Ctrl+V Intent
class _PasteImageIntent extends Intent {
  const _PasteImageIntent();
}

/// 대응 완료 다이얼로그
class ResponseCompleteDialog extends ConsumerStatefulWidget {
  const ResponseCompleteDialog({
    super.key,
    required this.entity,
    required this.organizationId,
  });

  final SystemLogEntity entity;
  final String organizationId;

  /// 다이얼로그 표시 및 결과 반환
  /// Returns: true = 성공, false = 실패, null = 취소
  static Future<bool?> show({
    required BuildContext context,
    required WidgetRef ref,
    required SystemLogEntity entity,
  }) async {
    final userDetail = await ref.read(currentUserDetailProvider.future);
    final organizationId = userDetail?.organizationId ?? 'unknown';

    if (!context.mounted) return null;

    final result = await showDialog<ResponseCompleteResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResponseCompleteDialog(
        entity: entity,
        organizationId: organizationId,
      ),
    );

    // 사용자가 취소함
    if (result == null) return null;

    final service = ref.read(eventResponseServiceProvider.notifier);
    final success = await service.completeResponseWithContent(
      entity,
      content: result.content,
      attachments: result.attachments.map((a) => a.toJson()).toList(),
    );

    return success;
  }

  @override
  ConsumerState<ResponseCompleteDialog> createState() => _ResponseCompleteDialogState();
}

class _ResponseCompleteDialogState extends ConsumerState<ResponseCompleteDialog> {
  late QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final List<AttachmentInfo> _attachments = [];
  bool _isUploading = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  void _setStatus(String message) {
    setState(() => _statusMessage = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _statusMessage = null);
    });
  }

  /// 클립보드에서 이미지 붙여넣기
  Future<void> _pasteImageFromClipboard() async {
    if (_isUploading) return;

    logger.i('[Dialog] Ctrl+V 또는 붙여넣기 버튼 클릭');
    _setStatus('클립보드 확인 중...');

    try {
      final imageBytes = await Pasteboard.image;

      if (imageBytes == null || imageBytes.isEmpty) {
        logger.w('[Dialog] 클립보드에 이미지 없음');
        _setStatus('클립보드에 이미지가 없습니다');
        return;
      }

      logger.i('[Dialog] 클립보드 이미지 발견: ${imageBytes.length} bytes');
      _setStatus('이미지 발견 (${(imageBytes.length / 1024).toStringAsFixed(0)}KB)');

      await _uploadAndInsertImage(imageBytes, 'clipboard_${DateTime.now().millisecondsSinceEpoch}.png');
    } catch (e, stack) {
      logger.e('[Dialog] 클립보드 처리 실패', error: e, stackTrace: stack);
      _setStatus('클립보드 오류: $e');
    }
  }

  /// 파일 선택
  Future<void> _pickImageFile() async {
    if (_isUploading) return;

    logger.i('[Dialog] 파일 선택 시작');

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        logger.d('[Dialog] 파일 선택 취소');
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        logger.w('[Dialog] 파일 경로 없음');
        _setStatus('파일 경로를 찾을 수 없습니다');
        return;
      }

      final bytes = await File(file.path!).readAsBytes();
      logger.i('[Dialog] 파일 선택: ${file.name} (${bytes.length} bytes)');
      _setStatus('파일 선택: ${file.name}');

      await _uploadAndInsertImage(bytes, file.name);
    } catch (e, stack) {
      logger.e('[Dialog] 파일 선택 실패', error: e, stackTrace: stack);
      _setStatus('파일 선택 오류: $e');
    }
  }

  /// 이미지 업로드 및 에디터에 삽입
  Future<void> _uploadAndInsertImage(Uint8List imageBytes, String fileName) async {
    setState(() => _isUploading = true);
    _setStatus('이미지 업로드 중...');

    try {
      logger.i('[Dialog] 업로드 시작: $fileName (${imageBytes.length} bytes)');

      final storageService = ref.read(attachmentStorageServiceProvider);
      final attachment = await storageService.uploadImage(
        imageBytes: imageBytes,
        fileName: fileName,
        organizationId: widget.organizationId,
      );

      if (attachment == null) {
        logger.e('[Dialog] 업로드 실패: attachment가 null');
        _setStatus('이미지 업로드 실패');
        return;
      }

      logger.i('[Dialog] 업로드 성공: ${attachment.url}');

      // 첨부파일 목록에 추가
      setState(() {
        _attachments.add(attachment);
      });

      // 에디터에 이미지 삽입
      final index = _controller.selection.extentOffset.clamp(0, _controller.document.length - 1);
      _controller.document.insert(index, BlockEmbed.image(attachment.url));
      _controller.moveCursorToEnd();

      logger.i('[Dialog] 에디터에 이미지 삽입 완료, 첨부파일 수: ${_attachments.length}');
      _setStatus('이미지 첨부 완료!');

    } catch (e, stack) {
      logger.e('[Dialog] 업로드 중 예외', error: e, stackTrace: stack);
      _setStatus('업로드 오류: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _removeAttachment(AttachmentInfo attachment) async {
    try {
      final storageService = ref.read(attachmentStorageServiceProvider);
      await storageService.deleteAttachment(attachment.url);
      setState(() {
        _attachments.remove(attachment);
      });
      _setStatus('첨부파일 삭제됨');
    } catch (e) {
      logger.e('[Dialog] 첨부파일 삭제 실패', error: e);
    }
  }

  String _getMarkdown() {
    try {
      final deltaToMd = DeltaToMarkdown();
      return deltaToMd.convert(_controller.document.toDelta());
    } catch (e) {
      return _controller.document.toPlainText();
    }
  }

  Map<String, dynamic> _getContent() {
    return {
      'markdown': _getMarkdown(),
      'delta': _controller.document.toDelta().toJson(),
      'version': 1,
    };
  }

  void _submit() {
    final markdown = _getMarkdown();
    final trimmedText = markdown.trim();
    if (trimmedText.length < 5) {
      _setStatus('조치 내역을 5자 이상 입력해주세요');
      return;
    }

    Navigator.of(context).pop(ResponseCompleteResult(
      markdown: markdown,
      content: _getContent(),
      attachments: _attachments,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyV, control: true): _PasteImageIntent(),
      },
      child: Actions(
        actions: {
          _PasteImageIntent: CallbackAction<_PasteImageIntent>(
            onInvoke: (_) {
              _pasteImageFromClipboard();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            child: Container(
              width: 850,
              height: 700,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 헤더
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // 상태 메시지
                  if (_statusMessage != null || _isUploading)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: _isUploading ? Colors.blue.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (_isUploading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _statusMessage ?? '업로드 중...',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 툴바
                  _buildToolbar(),
                  const SizedBox(height: 12),

                  // 에디터
                  Expanded(
                    flex: 3,
                    child: _buildEditor(),
                  ),

                  // 첨부파일 목록 (항상 표시)
                  const SizedBox(height: 12),
                  _buildAttachmentSection(),

                  const SizedBox(height: 16),

                  // 버튼
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '대응 완료',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                [
                  widget.entity.source,
                  if (widget.entity.site != null) widget.entity.site!,
                  if (widget.entity.code != null) widget.entity.code!,
                ].join(' - '),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _isUploading ? null : _pasteImageFromClipboard,
          icon: const Icon(Icons.content_paste, size: 18),
          label: const Text('붙여넣기 (Ctrl+V)'),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: _isUploading ? null : _pickImageFile,
          icon: const Icon(Icons.add_photo_alternate, size: 18),
          label: const Text('이미지 첨부'),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: QuillSimpleToolbar(
        controller: _controller,
        config: QuillSimpleToolbarConfig(
          showAlignmentButtons: false,
          showBackgroundColorButton: false,
          showColorButton: false,
          showFontFamily: false,
          showFontSize: false,
          showIndent: false,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
          showDirection: false,
          showListCheck: false,
          showClipboardCut: false,
          showClipboardCopy: false,
          showClipboardPaste: false,
          multiRowsDisplay: false,
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: QuillEditor(
        focusNode: _editorFocusNode,
        scrollController: _editorScrollController,
        controller: _controller,
        config: QuillEditorConfig(
          placeholder: '조치 내역을 입력하세요...',
          padding: const EdgeInsets.all(16),
          embedBuilders: FlutterQuillEmbeds.editorBuilders(),
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _attachments.isEmpty ? Colors.grey.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _attachments.isEmpty ? Colors.grey.shade300 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.image,
                size: 18,
                color: _attachments.isEmpty ? Colors.grey.shade500 : Colors.blue.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                _attachments.isEmpty ? '첨부된 이미지 없음' : '첨부 이미지 (${_attachments.length}개)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _attachments.isEmpty ? Colors.grey.shade500 : Colors.blue.shade700,
                ),
              ),
            ],
          ),
          if (_attachments.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _attachments.map((att) {
                return Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Chip(
                    avatar: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        att.url,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 18),
                      ),
                    ),
                    label: Text(
                      att.name,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeAttachment(att),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue.shade200),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Text(
          'Tip: 이미지를 복사한 후 Ctrl+V로 붙여넣기',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('취소'),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _isUploading ? null : _submit,
          icon: const Icon(Icons.check, size: 18),
          label: const Text('완료'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
