import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _ecgController;

  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _ecgAnim;

  @override
  void initState() {
    super.initState();

    // Force dark status bar on splash
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _ecgController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scaleAnim =
        Tween<double>(begin: 0.82, end: 1.0).animate(
            CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack));
    _ecgAnim =
        CurvedAnimation(parent: _ecgController, curve: Curves.easeInOut);

    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _ecgController.forward();
    });

    // Navigate to login after splash
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/auth/login');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _ecgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: Stack(
        children: [
          // Background scatter dots
          Positioned.fill(
            child: CustomPaint(painter: _DotsPainter()),
          ),

          // ECG waveform — centered
          Positioned(
            left: size.width * 0.1,
            right: size.width * 0.1,
            bottom: size.height * 0.28,
            child: AnimatedBuilder(
              animation: _ecgAnim,
              builder: (_, __) => CustomPaint(
                size: Size(size.width * 0.8, 100),
                painter: _EcgPainter(progress: _ecgAnim.value),
              ),
            ),
          ),

          // Tagline
          Positioned(
            top: size.height * 0.2,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: const Text(
                'Your health, your story',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: AppColors.zyvoTeal,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // ZÜVO logo — center
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: _ZUVOLogo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ZÜVO Logo ────────────────────────────────────────────────────────────────
class _ZUVOLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 86,
          fontWeight: FontWeight.w900,
          letterSpacing: -2,
          height: 1,
        ),
        children: [
          TextSpan(
            text: 'Z\u00dcV',
            style: TextStyle(color: AppColors.zyvoTeal),
          ),
          TextSpan(
            text: 'O',
            style: TextStyle(color: AppColors.zyvoLime),
          ),
        ],
      ),
    );
  }
}

// ─── ECG Waveform Painter ─────────────────────────────────────────────────────
class _EcgPainter extends CustomPainter {
  final double progress;
  _EcgPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.zyvoTeal
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ECG path points (normalized 0-1) — centered heartbeat
    final points = <Offset>[
      const Offset(0.00, 0.5),
      const Offset(0.08, 0.5),
      // First heartbeat — centered
      const Offset(0.28, 0.5),
      const Offset(0.31, 0.45),
      const Offset(0.33, 0.2),   // P wave
      const Offset(0.35, 0.5),
      const Offset(0.38, 0.55),
      const Offset(0.40, 0.1),   // QRS peak up
      const Offset(0.43, 0.95),  // QRS trough
      const Offset(0.46, 0.5),
      const Offset(0.51, 0.4),   // T wave
      const Offset(0.55, 0.5),
      // Second heartbeat
      const Offset(0.62, 0.5),
      const Offset(0.65, 0.45),
      const Offset(0.67, 0.2),
      const Offset(0.69, 0.5),
      const Offset(0.72, 0.55),
      const Offset(0.74, 0.1),
      const Offset(0.77, 0.95),
      const Offset(0.80, 0.5),
      const Offset(0.85, 0.4),
      const Offset(0.89, 0.5),
      const Offset(1.00, 0.5),
    ];

    final path = Path();
    if (points.isEmpty) return;

    // Map to canvas and clip to progress
    final totalLength = _pathLength(points, size);
    double drawn = 0;

    path.moveTo(points[0].dx * size.width, points[0].dy * size.height);

    for (int i = 1; i < points.length; i++) {
      final prev = Offset(points[i - 1].dx * size.width, points[i - 1].dy * size.height);
      final curr = Offset(points[i].dx * size.width, points[i].dy * size.height);
      final segLen = (curr - prev).distance;

      if (drawn / totalLength >= progress) break;

      final remaining = progress * totalLength - drawn;
      if (remaining >= segLen) {
        path.lineTo(curr.dx, curr.dy);
      } else {
        final t = remaining / segLen;
        path.lineTo(
          prev.dx + (curr.dx - prev.dx) * t,
          prev.dy + (curr.dy - prev.dy) * t,
        );
      }
      drawn += segLen;
    }

    canvas.drawPath(path, paint);
  }

  double _pathLength(List<Offset> points, Size size) {
    double total = 0;
    for (int i = 1; i < points.length; i++) {
      final p1 = Offset(points[i - 1].dx * size.width, points[i - 1].dy * size.height);
      final p2 = Offset(points[i].dx * size.width, points[i].dy * size.height);
      total += (p2 - p1).distance;
    }
    return total;
  }

  @override
  bool shouldRepaint(_EcgPainter old) => old.progress != progress;
}

// ─── Scatter Dots Painter ─────────────────────────────────────────────────────
class _DotsPainter extends CustomPainter {
  // Fixed dot positions [x%, y%, radius, colorIndex(0=purple,1=lime,2=tan)]
  static const _dots = [
    // Purple cluster (left-center)
    [0.26, 0.46, 14.0, 0],
    [0.32, 0.40, 10.0, 0],
    [0.22, 0.52, 8.0, 0],
    [0.28, 0.58, 12.0, 0],
    [0.18, 0.44, 7.0, 0],
    [0.36, 0.50, 9.0, 0],
    [0.24, 0.35, 6.0, 0],
    [0.30, 0.62, 7.0, 0],
    // Green cluster (right-center)
    [0.58, 0.38, 16.0, 1],
    [0.66, 0.32, 12.0, 1],
    [0.72, 0.28, 20.0, 1],
    [0.62, 0.46, 9.0, 1],
    [0.68, 0.42, 11.0, 1],
    [0.76, 0.36, 8.0, 1],
    [0.56, 0.50, 6.0, 1],
    [0.70, 0.52, 7.0, 1],
    // Tan cluster (bottom-center)
    [0.38, 0.70, 9.0, 2],
    [0.44, 0.74, 7.0, 2],
    [0.50, 0.72, 11.0, 2],
    [0.42, 0.80, 8.0, 2],
    [0.48, 0.66, 6.0, 2],
    [0.54, 0.78, 9.0, 2],
    [0.36, 0.76, 5.0, 2],
    [0.56, 0.68, 7.0, 2],
    [0.46, 0.84, 6.0, 2],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const colors = [AppColors.zyvoPurple, AppColors.zyvoLime, AppColors.tanAccent];
    for (final d in _dots) {
      final paint = Paint()
        ..color = colors[(d[3] as num).toInt()].withOpacity(0.55)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset((d[0] as num).toDouble() * size.width, (d[1] as num).toDouble() * size.height),
        (d[2] as num).toDouble(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DotsPainter _) => false;
}
