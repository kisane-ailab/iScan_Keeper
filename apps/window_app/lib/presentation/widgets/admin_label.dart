import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/user_role.dart';
import 'package:window_app/domain/services/event_response_service.dart';

/// 앱바 타이틀 옆에 표시되는 Admin 라벨
class AdminLabel extends ConsumerWidget {
  const AdminLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailAsync = ref.watch(currentUserDetailProvider);

    return userDetailAsync.when(
      data: (user) {
        if (user == null || !user.role.isManagerOrAbove) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: user.role.isAdmin
                ? CupertinoColors.systemRed.withValues(alpha: 0.15)
                : CupertinoColors.systemOrange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: user.role.isAdmin
                  ? CupertinoColors.systemRed.withValues(alpha: 0.3)
                  : CupertinoColors.systemOrange.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            user.role.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: user.role.isAdmin
                  ? CupertinoColors.systemRed
                  : CupertinoColors.systemOrange,
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// 앱바 타이틀 + Admin 라벨을 함께 표시하는 위젯
class AppBarTitleWithLabel extends ConsumerWidget {
  const AppBarTitleWithLabel({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const AdminLabel(),
      ],
    );
  }
}

/// 우측 상단 대각선 리본 배너 (Debug 배너 스타일)
class AdminRibbonBanner extends ConsumerWidget {
  const AdminRibbonBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailAsync = ref.watch(currentUserDetailProvider);

    return userDetailAsync.when(
      data: (user) {
        if (user == null || !user.role.isManagerOrAbove) {
          return child;
        }

        return Stack(
          children: [
            child,
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                painter: _RibbonPainter(
                  color: user.role.isAdmin
                      ? CupertinoColors.systemRed
                      : CupertinoColors.systemOrange,
                ),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Transform.rotate(
                    angle: 0.785398, // 45 degrees
                    child: Align(
                      alignment: const Alignment(0.0, 0.65),
                      child: Text(
                        user.role.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

/// 리본 배너 페인터
class _RibbonPainter extends CustomPainter {
  _RibbonPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.7)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// 프로필에서 사용하는 역할 뱃지 위젯
class RoleBadge extends StatelessWidget {
  const RoleBadge({
    super.key,
    required this.role,
    this.size = RoleBadgeSize.medium,
  });

  final UserRole role;
  final RoleBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final (fontSize, paddingH, paddingV, iconSize) = switch (size) {
      RoleBadgeSize.small => (10.0, 6.0, 2.0, 12.0),
      RoleBadgeSize.medium => (12.0, 10.0, 4.0, 16.0),
      RoleBadgeSize.large => (14.0, 12.0, 6.0, 20.0),
    };

    final (bgColor, textColor, icon) = switch (role) {
      UserRole.admin => (
          CupertinoColors.systemRed.withValues(alpha: 0.15),
          CupertinoColors.systemRed,
          CupertinoIcons.shield_fill,
        ),
      UserRole.manager => (
          CupertinoColors.systemOrange.withValues(alpha: 0.15),
          CupertinoColors.systemOrange,
          CupertinoIcons.person_badge_plus_fill,
        ),
      UserRole.member => (
          CupertinoColors.systemGrey.withValues(alpha: 0.15),
          CupertinoColors.systemGrey,
          CupertinoIcons.person_fill,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: textColor),
          const SizedBox(width: 4),
          Text(
            role.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum RoleBadgeSize { small, medium, large }
