import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() { _loading = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: Stack(
        children: [
          // subtle background dots
          Positioned.fill(
            child: CustomPaint(painter: _DotsPainter()),
          ),

          SafeArea(
            child: Column(
              children: [
                // top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // card
                Container(
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000), blurRadius: 40, offset: Offset(0, -8)),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _sent
                        ? _buildSuccess()
                        : _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Success state
  Widget _buildSuccess() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: AppColors.zyvoTeal.withOpacity(0.12), shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined, size: 32, color: AppColors.zyvoTeal),
        ),
        const SizedBox(height: 20),
        Text('Check your email',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textH)),
        const SizedBox(height: 10),
        Text(
          'We sent a password reset link to\n${_emailCtrl.text.trim()}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.textM, height: 1.5),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zyvoTeal, foregroundColor: AppColors.zyvoNavy, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Back to Sign In',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Form state
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // icon
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
            color: AppColors.zyvoTeal.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.lock_reset_outlined, color: AppColors.zyvoTeal, size: 26),
          ),
          const SizedBox(height: 16),
          Text('Forgot password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textH)),
          const SizedBox(height: 6),
          Text("Enter your email and we'll send you a reset link.",
            style: TextStyle(fontSize: 14, color: context.textM, height: 1.5)),
          const SizedBox(height: 28),

          // label
          Text('Email address',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              letterSpacing: 0.4, color: context.textM)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email address';
              return null;
            },
            style: TextStyle(fontSize: 14, color: context.textH),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              filled: true, fillColor: context.isDark ? AppColors.darkBackgroundColor : AppColors.fillLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.zyvoTeal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.errorAlt),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.errorAlt, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity, height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zyvoTeal, foregroundColor: AppColors.zyvoNavy, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.zyvoNavy)))
                  : const Text('Send Reset Link',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Subtle background dots painter
class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.zyvoTeal.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height * 0.6; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
