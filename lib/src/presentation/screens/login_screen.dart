import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/providers/auth_providers.dart';

// ─── Health icon columns for scrolling background ─────────────────────────────
const _kCol0 = <IconData>[
  Icons.favorite_rounded,
  Icons.trending_up_rounded,
  Icons.water_drop_rounded,
  Icons.monitor_heart_rounded,
  Icons.science_rounded,
  Icons.bar_chart_rounded,
  Icons.health_and_safety_rounded,
];

const _kCol1 = <IconData>[
  Icons.show_chart_rounded,
  Icons.medical_services_rounded,
  Icons.analytics_rounded,
  Icons.directions_run_rounded,
  Icons.psychology_rounded,
  Icons.healing_rounded,
  Icons.biotech_rounded,
];

const _kCol2 = <IconData>[
  Icons.fitness_center_rounded,
  Icons.nights_stay_rounded,
  Icons.monitor_heart_rounded,
  Icons.bar_chart_rounded,
  Icons.medication_rounded,
  Icons.trending_up_rounded,
  Icons.water_drop_rounded,
];

// ─── Screen steps ─────────────────────────────────────────────────────────────
enum _Step { landing, phone, otp }

// ─── LoginScreen ──────────────────────────────────────────────────────────────
class LoginScreen extends ConsumerStatefulWidget {
  final bool isSignup;
  const LoginScreen({super.key, this.isSignup = false});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  // Background scroll controllers
  late final List<AnimationController> _cols;

  // Step state
  late _Step _step;
  late bool _signupMode;

  // Phone step
  final _phoneCtrl = TextEditingController();
  final _phoneKey = GlobalKey<FormState>();

  // OTP step — 6 individual boxes
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpNodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _signupMode = widget.isSignup;
    _step = _Step.landing;

    _cols = [
      AnimationController(vsync: this, duration: const Duration(seconds: 14))
        ..repeat(),
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat(),
      AnimationController(vsync: this, duration: const Duration(seconds: 17))
        ..repeat(),
    ];
  }

  @override
  void dispose() {
    for (final c in _cols) c.dispose();
    _phoneCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final n in _otpNodes) n.dispose();
    super.dispose();
  }

  void _goToPhone(bool signup) =>
      setState(() { _signupMode = signup; _step = _Step.phone; });

  void _goToOtp() {
    if (!(_phoneKey.currentState?.validate() ?? false)) return;
    setState(() => _step = _Step.otp);
    // Autofocus first OTP box
    Future.microtask(() => _otpNodes[0].requestFocus());
  }

  void _verifyOtp() {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
      _signupMode ? context.go('/onboarding') : context.go('/home');
    });
  }

  void _resendOtp() {
    // UI only — reset boxes and go back to show "Sent" state
    for (final c in _otpCtrls) c.clear();
    _otpNodes[0].requestFocus();
  }

  // ── Background helpers ─────────────────────────────────────────────────────
  Widget _cell(IconData icon, Color color) => Container(
        width: 88,
        height: 88,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Icon(icon, color: color.withOpacity(0.65), size: 34),
      );

  Widget _scrollCol(List<IconData> icons, AnimationController ctrl,
      Color color, double viewH, {bool reverse = false}) {
    const cellH = 104.0;
    final total = icons.length * cellH;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final offset = (reverse ? 1.0 - ctrl.value : ctrl.value) * total;
        return SizedBox(
          width: 104,
          height: viewH,
          child: ClipRect(
            child: OverflowBox(
              maxHeight: total * 2 + viewH,
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(0, -offset),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...icons.map((ic) => _cell(ic, color)),
                    ...icons.map((ic) => _cell(ic, color)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final kb = MediaQuery.of(context).viewInsets.bottom;
    final iconAreaH = size.height * 0.70;

    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Scrolling icons
          Positioned(
            top: 0, left: 0, right: 0, height: iconAreaH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _scrollCol(_kCol0, _cols[0], AppColors.zyvoTeal, iconAreaH),
                _scrollCol(_kCol1, _cols[1], AppColors.zyvoPurple, iconAreaH, reverse: true),
                _scrollCol(_kCol2, _cols[2], AppColors.zyvoLime, iconAreaH),
              ],
            ),
          ),

          // Gradient fade
          Positioned(
            top: iconAreaH * 0.3, left: 0, right: 0,
            height: iconAreaH * 0.7 + 40,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.zyvoNavy.withOpacity(0),
                      AppColors.zyvoNavy.withOpacity(0.8),
                      AppColors.zyvoNavy,
                    ],
                    stops: const [0, 0.4, 0.72],
                  ),
                ),
              ),
            ),
          ),

          // Bottom card
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            bottom: kb,
            left: 0, right: 0,
            child: Builder(builder: (context) {
              return Container(
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 32,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.06, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOut)),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: switch (_step) {
                      _Step.landing => _landing(),
                      _Step.phone   => _phoneStep(),
                      _Step.otp     => _otpStep(),
                    },
                  ),
                ),
              ),
            );}),
          ),
        ],
      ),
    );
  }

  // ── Step 0: Landing ────────────────────────────────────────────────────────
  Widget _landing() {
    return Column(
      key: const ValueKey('landing'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppColors.zyvoNavy, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.monitor_heart_rounded, color: AppColors.zyvoTeal, size: 28),
            ),
            const SizedBox(width: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900,
                    letterSpacing: -1.5),
                children: [
                  TextSpan(text: 'ZÜV', style: TextStyle(color: AppColors.zyvoTeal)),
                  TextSpan(text: 'O', style: TextStyle(color: AppColors.zyvoLime)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Your health, your story',
          style: TextStyle(fontSize: 14, color: context.textM),
        ),
        const SizedBox(height: 30),

        // Login CTA
        SizedBox(
          width: double.infinity, height: 58,
          child: ElevatedButton(
            onPressed: () => _goToPhone(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zyvoTeal, elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.phone_rounded, size: 22, color: AppColors.zyvoNavy),
                SizedBox(width: 10),
                Text('Login with Phone Number',
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700, color: AppColors.zyvoNavy)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Sign up CTA
        SizedBox(
          width: double.infinity, height: 52,
          child: OutlinedButton(
            onPressed: () => _goToPhone(true),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.zyvoTeal, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: const Text('Sign Up',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: AppColors.zyvoTeal)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'By continuing, you agree to our Terms of Service & Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: context.textL),
        ),
      ],
    );
  }

  // ── Step 1: Phone number entry ─────────────────────────────────────────────
  Widget _phoneStep() {
    return Column(
      key: const ValueKey('phone'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          onBack: () => setState(() => _step = _Step.landing),
          title: _signupMode ? 'Create Account' : 'Welcome Back',
        ),
        const SizedBox(height: 6),
        Text(
          _signupMode
              ? 'Enter your mobile number to get started'
              : 'Enter your mobile number to continue',
          style: TextStyle(fontSize: 13, color: context.textM),
        ),
        const SizedBox(height: 24),

        Form(
          key: _phoneKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mobile Number',
                  style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w500, color: context.textM)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onFieldSubmitted: (_) => _goToOtp(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone number is required';
                  if (v.length < 10) return 'Enter a valid 10-digit number';
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '9876543210',
                  hintStyle: const TextStyle(
                      fontSize: 16, color: AppColors.placeholderGray),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇮🇳',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text('+91',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: context.textH)),
                        const SizedBox(width: 8),
                        SizedBox(
                            height: 20,
                            child: VerticalDivider(
                                color: context.border, width: 1)),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(),
                  filled: true,
                  fillColor: context.surface2,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
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
                    borderSide:
                        const BorderSide(color: AppColors.zyvoTeal, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.errorAlt),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.errorAlt, width: 1.5),
                  ),
                  errorStyle: const TextStyle(
                      fontSize: 11, color: AppColors.errorAlt),
                ),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: context.textH,
                    letterSpacing: 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: _goToOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zyvoTeal, elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Send OTP',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: AppColors.zyvoNavy)),
          ),
        ),
        const SizedBox(height: 14),

        Center(
          child: GestureDetector(
            onTap: () => setState(() => _signupMode = !_signupMode),
            child: Text.rich(
              TextSpan(
                text: _signupMode
                    ? 'Already have an account? '
                    : "Don't have an account? ",
                style: TextStyle(
                    fontSize: 13, color: AppColors.textColorMuted),
                children: [
                  TextSpan(
                    text: _signupMode ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.zyvoTeal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Step 2: OTP entry ──────────────────────────────────────────────────────
  Widget _otpStep() {
    final phone = _phoneCtrl.text.trim();
    final maskedPhone = phone.length >= 10
        ? '+91 ${phone.substring(0, 2)}•••••${phone.substring(7)}'
        : '+91 $phone';

    return Column(
      key: const ValueKey('otp'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          onBack: () => setState(() => _step = _Step.phone),
          title: 'Enter OTP',
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            text: 'We sent a 6-digit code to ',
            style: TextStyle(fontSize: 13, color: context.textM),
            children: [
              TextSpan(
                text: maskedPhone,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.textH),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // 6 OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _otpBox(i)),
        ),
        const SizedBox(height: 30),

        // Verify button
        SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: _loading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zyvoTeal,
              disabledBackgroundColor: AppColors.zyvoTeal.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                : Text(
                    _signupMode ? 'Create Account' : 'Login',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.zyvoNavy)),
          ),
        ),
        const SizedBox(height: 18),

        // Resend row
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Didn't receive the code? ",
                  style: TextStyle(
                      fontSize: 13, color: context.textM)),
              GestureDetector(
                onTap: _resendOtp,
                child: const Text('Resend OTP',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.zyvoTeal,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.zyvoTeal)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _step = _Step.phone),
            child: Text('Change number',
                style: TextStyle(
                    fontSize: 12, color: context.textL)),
          ),
        ),
      ],
    );
  }

  // ── OTP single box ─────────────────────────────────────────────────────────
  Widget _otpBox(int i) {
    return SizedBox(
      width: 46, height: 54,
      child: TextField(
        controller: _otpCtrls[i],
        focusNode: _otpNodes[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.textH),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: context.surface2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.zyvoTeal, width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (v) {
          if (v.isNotEmpty && i < 5) {
            _otpNodes[i + 1].requestFocus();
          } else if (v.isEmpty && i > 0) {
            _otpNodes[i - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }

  // ── Shared step header ─────────────────────────────────────────────────────
  Widget _stepHeader({required VoidCallback onBack, required String title}) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: context.textH),
          ),
        ),
        const SizedBox(width: 14),
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.textH)),
      ],
    );
  }
}
