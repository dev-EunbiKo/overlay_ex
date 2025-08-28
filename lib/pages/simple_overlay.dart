import 'dart:async';

import 'package:flutter/material.dart';

class SimpleOverlay extends StatefulWidget {
  const SimpleOverlay({super.key});

  @override
  State<SimpleOverlay> createState() => _SimpleOverlayState();
}

class _SimpleOverlayState extends State<SimpleOverlay> {
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder:
            (context) => Positioned(
              top: 100,
              left: 50,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text('Simple Overlay', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    } else {}
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 자동 제거 오버레이
  void _showAutoRemoveOverlay() {
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned.fill(
            child: Material(
              color: Colors.grey.shade100.withAlpha(100),
              child: Center(
                child: CircularProgressIndicator(color: Colors.grey.shade900),
              ),
            ),
          ),
    );
    Overlay.of(context).insert(overlayEntry);

    Timer(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // dispose에서 반드시 오버레이 제거
    _hideOverlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 페이지 이동 시에도 오버레이 제거
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showOverlay,
              child: Text('show Overlay'),
            ),
            ElevatedButton(
              onPressed: _hideOverlay,
              child: Text('hide Overlay'),
            ),
            ElevatedButton(
              onPressed: _showAutoRemoveOverlay,
              child: Text('Auto Remove Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}
