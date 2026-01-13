import 'package:flutter/cupertino.dart';

/// Mute 규칙 설정 다이얼로그 결과
class MuteRuleDialogResult {
  final bool includeSource;
  final bool includeCode;
  final String source;
  final String? code;

  MuteRuleDialogResult({
    required this.includeSource,
    required this.includeCode,
    required this.source,
    required this.code,
  });

  /// 실제 저장할 source 값 (체크 해제 시 null)
  String? get effectiveSource => includeSource ? source : null;

  /// 실제 저장할 code 값 (체크 해제 시 null)
  String? get effectiveCode => includeCode ? code : null;
}

/// Mute 규칙 설정 다이얼로그
class MuteRuleDialog extends StatefulWidget {
  const MuteRuleDialog({
    super.key,
    required this.source,
    this.code,
  });

  final String source;
  final String? code;

  /// 다이얼로그 표시
  static Future<MuteRuleDialogResult?> show({
    required BuildContext context,
    required String source,
    String? code,
  }) {
    return showCupertinoDialog<MuteRuleDialogResult>(
      context: context,
      builder: (context) => MuteRuleDialog(
        source: source,
        code: code,
      ),
    );
  }

  @override
  State<MuteRuleDialog> createState() => _MuteRuleDialogState();
}

class _MuteRuleDialogState extends State<MuteRuleDialog> {
  bool _includeSource = true;
  bool _includeCode = true;

  @override
  void initState() {
    super.initState();
    // code가 없으면 체크박스 비활성화
    if (widget.code == null) {
      _includeCode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('이 종류의 알림 숨기기'),
      content: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '다음 조건에 해당하는 알림을 숨깁니다.',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
            const SizedBox(height: 16),
            // Source 체크박스
            _CheckboxRow(
              label: 'Source',
              value: widget.source,
              isChecked: _includeSource,
              onChanged: (value) {
                setState(() => _includeSource = value);
              },
            ),
            const SizedBox(height: 8),
            // Code 체크박스
            if (widget.code != null)
              _CheckboxRow(
                label: 'Code',
                value: widget.code!,
                isChecked: _includeCode,
                onChanged: (value) {
                  setState(() => _includeCode = value);
                },
              ),
            if (widget.code == null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Code: (없음)',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // 설명
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getDescription(),
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('취소'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: _canSubmit()
              ? () {
                  Navigator.of(context).pop(MuteRuleDialogResult(
                    includeSource: _includeSource,
                    includeCode: _includeCode,
                    source: widget.source,
                    code: widget.code,
                  ));
                }
              : null,
          child: const Text('숨기기'),
        ),
      ],
    );
  }

  bool _canSubmit() {
    // 최소 하나는 선택해야 함
    return _includeSource || _includeCode;
  }

  String _getDescription() {
    if (!_includeSource && !_includeCode) {
      return '조건을 하나 이상 선택해주세요.';
    }

    final parts = <String>[];
    if (_includeSource) {
      parts.add('출처가 "${widget.source}"');
    }
    if (_includeCode && widget.code != null) {
      parts.add('코드가 "${widget.code}"');
    }

    if (parts.length == 2) {
      return '${parts[0]}이고 ${parts[1]}인 알림을 숨깁니다.';
    } else if (parts.length == 1) {
      return '${parts[0]}인 모든 알림을 숨깁니다.';
    }
    return '';
  }
}

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.label,
    required this.value,
    required this.isChecked,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Row(
        children: [
          // Cupertino 스타일 체크박스
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isChecked
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isChecked
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey.resolveFrom(context),
                width: 1.5,
              ),
            ),
            child: isChecked
                ? const Icon(
                    CupertinoIcons.checkmark,
                    size: 16,
                    color: CupertinoColors.white,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isChecked
                  ? CupertinoColors.label.resolveFrom(context)
                  : CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: isChecked
                    ? CupertinoColors.label.resolveFrom(context)
                    : CupertinoColors.tertiaryLabel.resolveFrom(context),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
