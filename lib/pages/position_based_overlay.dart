import 'package:flutter/material.dart';

class PositionBasedOverlay extends StatefulWidget {
  const PositionBasedOverlay({super.key});

  @override
  State<PositionBasedOverlay> createState() => _PositionBasedOverlayState();
}

class _PositionBasedOverlayState extends State<PositionBasedOverlay> {
  final GlobalKey _buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _positionOverlayEntry;
  OverlayEntry? _followOverlayEntry;

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  /// 전체 오버레이 제거
  void _hideOverlay() {
    _positionOverlayEntry?.remove();
    _positionOverlayEntry = null;
    _followOverlayEntry?.remove();
    _followOverlayEntry = null;
  }

  /// 위치 기반 동적 오버레이 show
  void _showContextMenu() {
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    if (_positionOverlayEntry == null) {
      _positionOverlayEntry = OverlayEntry(
        builder:
            (context) => Positioned(
              left: position.dx,
              top: position.dy + size.height + 8,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.amber),
                        title: Text('STAR'),
                        onTap: () => _hideOverlay(),
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite, color: Colors.red),
                        title: Text('HEART'),
                        onTap: () => _hideOverlay(),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.water_drop,
                          color: Colors.lightBlue.shade200,
                        ),
                        title: Text('WATER'),
                        onTap: () => _hideOverlay(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );

      Overlay.of(context).insert(_positionOverlayEntry!);
    }
  }

  /// CompositedTransformFollower/Target을 이용한 고급 위치 추적
  void _showFollowerOverlay() {
    if (_followOverlayEntry == null) {
      _followOverlayEntry = OverlayEntry(
        builder:
            (context) => CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, 0), // 타겟 위젯 위치
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.green.shade200,
                  width: 250,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Advanced Overlay',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This overlay follows the target widget exactly.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _hideOverlay,
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );

      Overlay.of(context).insert(_followOverlayEntry!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showContextMenu,
              key: _buttonKey,
              child: Text('Context Menu'),
            ),
            CompositedTransformTarget(
              link: _layerLink,
              child: Center(
                child: ElevatedButton(
                  onPressed: _showFollowerOverlay,
                  child: Text('Follower Overlay'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
