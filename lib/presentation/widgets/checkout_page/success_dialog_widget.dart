import "package:flutter/material.dart";
import "../../../core/constants/app_colors.dart";

class SuccessDialog extends StatefulWidget {
  final VoidCallback onComplete;
  const SuccessDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)));
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeInOut)));
    _rippleAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOut)));

    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20))
              ]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Stack(alignment: Alignment.center, children: [
                    Container(
                        width: 120 * _rippleAnimation.value,
                        height: 120 * _rippleAnimation.value,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [
                              AppColors.success.withOpacity(0.3 *
                                  (1 - (_rippleAnimation.value - 0.8) / 0.7)),
                              AppColors.success.withOpacity(0)
                            ]))),
                    Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.success, Color(0xFF2EA043)]),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.success.withOpacity(0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12))
                            ]),
                        child: Center(
                            child: AnimatedBuilder(
                                animation: _checkAnimation,
                                builder: (context, child) => CustomPaint(
                                    size: const Size(60, 60),
                                    painter: _CheckPainter(
                                        progress: _checkAnimation.value))))),
                  ]);
                }),
            const SizedBox(height: 32),
            ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2A2A2A)])
                    .createShader(bounds),
                child: const Text("Order Placed!",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5))),
            const SizedBox(height: 12),
            const Text(
                "Your order has been successfully placed\nWe\\'ll notify you when it\\'s on the way",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: AppColors.secondary, height: 1.5)),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent
                                    .withOpacity(value * 0.6)))))),
          ]),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path();
    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.42, size.height * 0.72);
    final p3 = Offset(size.width * 0.82, size.height * 0.28);

    if (progress <= 0.5) {
      final currentProgress = progress / 0.5;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx + (p2.dx - p1.dx) * currentProgress,
          p1.dy + (p2.dy - p1.dy) * currentProgress);
    } else {
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      final currentProgress = (progress - 0.5) / 0.5;
      path.lineTo(p2.dx + (p3.dx - p2.dx) * currentProgress,
          p2.dy + (p3.dy - p2.dy) * currentProgress);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
