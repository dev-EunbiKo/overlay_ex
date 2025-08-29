import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlay_ex/utils/toast_manager.dart';

class SimpleOverlay extends StatefulWidget {
  const SimpleOverlay({super.key});

  @override
  State<SimpleOverlay> createState() => _SimpleOverlayState();
}

class _SimpleOverlayState extends State<SimpleOverlay> {
  OverlayEntry? _overlayEntry;

  final OverlayPortalController _portalController = OverlayPortalController();

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

  /// 기본 오버레이
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
    }
  }

  /// 반응형 오버레이
  void _showResponsiveOverlay() {
    final overlayEntry = _createResponsiveOverlay();
    Overlay.of(context).insert(overlayEntry);

    Timer(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  /// 반응형 오버레이 생성
  OverlayEntry _createResponsiveOverlay() {
    return OverlayEntry(
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final isTablet = screenSize.width > 600;

        return Positioned.fill(
          child: Material(
            color: Colors.grey.shade100.withAlpha(100),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                width:
                    isTablet ? screenSize.width * 0.8 : screenSize.width - 40,
                height: screenSize.height * 0.2,
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Responsive Overlay',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      'The Overlay Size will be changed according to Screen Size.',
                      style: TextStyle(color: Colors.grey.shade900),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

  Widget _portalBuilder() {
    return Positioned(
      top: 100,
      left: 50,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Overlay by OverlayPortal'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _portalController.hide(),
                child: Text('close'),
              ),
            ],
          ),
        ),
      ),
    );
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
            ElevatedButton(
              onPressed: _showResponsiveOverlay,
              child: Text('Responsive Overlay'),
            ),

            SizedBox(height: 20),
            OverlayPortal(
              controller: _portalController,
              overlayChildBuilder: (context) {
                return _portalBuilder();
              },
              child: ElevatedButton(
                onPressed: _portalController.show,
                child: Text('Overlay Portal'),
              ),
            ),

            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed:
                      () => ToastManager.showToast(
                        context: context,
                        message: 'Toast Message',
                        type: ToastType.success,
                      ),
                  child: Text('Success'),
                ),
                // ElevatedButton(
                //   onPressed:
                //       () => ToastManager.showToast(
                //         context: context,
                //         message: 'Toast Message',
                //         type: ToastType.info,
                //       ),
                //   child: Text('Info'),
                // ),
                // ElevatedButton(
                //   onPressed:
                //       () => ToastManager.showToast(
                //         context: context,
                //         message: 'Toast Message',
                //         type: ToastType.error,
                //       ),
                //   child: Text('Error'),
                // ),
                // ElevatedButton(
                //   onPressed:
                //       () => ToastManager.showToast(
                //         context: context,
                //         message: 'Toast Message',
                //         type: ToastType.warning,
                //       ),
                //   child: Text('Warning'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
