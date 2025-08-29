// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

enum ToastType { success, info, error, warning }

// TODO: 오류 CHECK !! >>> 여러 개를 여러 번 보여주려면 List로 된 EntryQueue를 만들어서 해야 할 듯
/// 오버레이를 사용한 토스트 메시지
class ToastManager {
  static OverlayEntry? _currentToast;

  static void showToast({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    ToastType type = ToastType.info,
  }) {
    _currentToast?.remove();

    _currentToast = OverlayEntry(
      builder:
          (context) => _ToastWidget(
            message: message,
            type: type,
            duration: duration,
            onDismiss: () {
              _currentToast?.remove();
              _currentToast = null;
            },
          ),
    );

    Overlay.of(context).insert(_currentToast!);
  }
}

/// 애니메이션 효과
class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController? _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController!);

    super.initState();

    _animationController?.forward();

    Timer(widget.duration, () {
      _hideToast();
    });
  }

  void _hideToast() async {
    _animationController?.reverse();
    _timer?.cancel();
    widget.onDismiss();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade200;
      case ToastType.info:
        return Colors.lightBlueAccent.shade200;
      case ToastType.error:
        return Colors.red.shade200;
      case ToastType.warning:
        return Colors.yellow.shade200;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check;
      case ToastType.info:
        return Icons.info;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(_getIcon(), color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
