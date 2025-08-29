import 'package:flutter/material.dart';

class AnimationOverlay extends StatefulWidget {
  const AnimationOverlay({super.key});

  @override
  State<AnimationOverlay> createState() => _AnimationOverlayState();
}

class _AnimationOverlayState extends State<AnimationOverlay>
    with TickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _hideAnimatedOverlay();
    _animationController.dispose();
  }

  void _showAnimatedOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned.fill(
                child: Material(
                  color: Colors.black.withValues(
                    alpha: 0.5 * _opacityAnimation.value,
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 50, color: Colors.amber),
                            SizedBox(height: 16),
                            Text(
                              'Animation Overlay',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Widget will be presented with soft animation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _hideAnimatedOverlay,
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideAnimatedOverlay() async {
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _showAnimatedOverlay,
          child: Text('Show Animated Overlay'),
        ),
      ),
    );
  }
}
