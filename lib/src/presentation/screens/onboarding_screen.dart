import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/providers/auth_providers.dart';
import 'package:health_trace/src/presentation/providers/user_profile_provider.dart';

//  Slide data 
class _Slide {
  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  const _Slide({required this.icon, required this.accent, required this.title, required this.subtitle});
}

const _slides = [
  _Slide(
    icon: Icons.upload_file_outlined,
    accent: AppColors.zyvoTeal,
    title: 'Upload Any Medical Record',
    subtitle: 'PDFs, photos, X-rays, MRIs, blood reports — all in one secure place.',
  ),
  _Slide(
    icon: Icons.memory_outlined,
    accent: AppColors.zyvoPurple,
    title: 'Smart Data Extraction',
    subtitle: 'ZÜVO reads your reports and extracts structured health data — you verify and confirm.',
  ),
  _Slide(
    icon: Icons.trending_up,
    accent: AppColors.zyvoLime,
    title: 'Track Your Health Trends',
    subtitle: 'See how key parameters change over time. Spot patterns before they become problems.',
  ),
  _Slide(
    icon: Icons.medical_services_outlined,
    accent: AppColors.zyvoTeal,
    title: 'Prepare for Doctor Visits',
    subtitle: "Generate a smart summary tailored to your doctor's specialty. Never miss important details.",
  ),
];

//  Flow steps 
enum _FlowStep { slides, terms, profileSetup, complete }

//  Root widget 
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _FlowStep _flowStep = _FlowStep.slides;
  int _slideIndex = 0;

  final Map<String, dynamic> _profileData = {
    'name': '', 'dob': '', 'sex': '', 'height': '', 'weight': '',
    'conditions': <String>[], 'medications': <String>[''],
    'allergies': <String>[''], 'smoking': '', 'alcohol': '', 'activity': '',
  };

  @override
  Widget build(BuildContext context) {
    switch (_flowStep) {
      case _FlowStep.slides:
        return _SlidesScreen(
          slideIndex: _slideIndex,
          onNext: () {
            if (_slideIndex < _slides.length - 1) {
              setState(() => _slideIndex++);
            } else {
              setState(() => _flowStep = _FlowStep.terms);
            }
          },
          onSkip: () => setState(() => _flowStep = _FlowStep.terms),
        );
      case _FlowStep.terms:
        return _TermsScreen(
          onAccept: () => setState(() => _flowStep = _FlowStep.profileSetup),
        );
      case _FlowStep.profileSetup:
        return _ProfileSetupFlow(
          profileData: _profileData,
          onComplete: () => setState(() => _flowStep = _FlowStep.complete),
        );
      case _FlowStep.complete:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(authStateProvider.notifier).setAuthenticated(true);
            context.go('/home');
          }
        });
        return const Scaffold(
          backgroundColor: AppColors.zyvoNavy,
          body: Center(child: CircularProgressIndicator(color: AppColors.zyvoTeal)),
        );
    }
  }
}

//  Slides Screen 
class _SlidesScreen extends StatelessWidget {
  final int slideIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _SlidesScreen({required this.slideIndex, required this.onNext, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final slide = _slides[slideIndex];
    final isLast = slideIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                child: GestureDetector(
                  onTap: onSkip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),

            // Illustration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _SlideIllustration(key: ValueKey(slideIndex), slide: slide),
                ),
              ),
            ),

            // Card with text + dots + button
            Builder(builder: (context) {
              final inactiveDot = context.border;
              return Container(
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 32, offset: Offset(0, -4)),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey(slideIndex),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.textH,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      slide.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: context.textM, height: 1.6),
                    ),
                    const SizedBox(height: 24),

                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == slideIndex ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == slideIndex ? AppColors.zyvoTeal : inactiveDot,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.zyvoTeal,
                          foregroundColor: AppColors.zyvoNavy,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          isLast ? 'Get Started' : 'Next',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );}),
          ],
        ),
      ),
    );
  }
}

// Illustration widget per slide
class _SlideIllustration extends StatelessWidget {
  final _Slide slide;
  const _SlideIllustration({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.accent.withOpacity(0.08),
            ),
          ),
          // Inner ring
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.accent.withOpacity(0.15),
            ),
          ),
          // Icon
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.accent.withOpacity(0.2),
              border: Border.all(color: slide.accent.withOpacity(0.4), width: 2),
            ),
            child: Icon(slide.icon, size: 44, color: slide.accent),
          ),
        ],
      ),
    );
  }
}

//  Terms Screen 
class _TermsScreen extends StatefulWidget {
  final VoidCallback onAccept;
  const _TermsScreen({required this.onAccept});
  @override
  State<_TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<_TermsScreen> {
  bool _accepted = false;

  static const _termSections = [
    (
      icon: Icons.shield_outlined,
      color: AppColors.zyvoTeal,
      title: 'Your Data is Private',
      body: 'All health records are stored securely and encrypted. We never sell your data or share it with third parties without your consent.',
    ),
    (
      icon: Icons.cloud_outlined,
      color: AppColors.zyvoPurple,
      title: 'Secure Storage',
      body: 'Your data is encrypted in transit and at rest. You can delete your account and all associated data at any time.',
    ),
    (
      icon: Icons.verified_outlined,
      color: AppColors.zyvoLime,
      title: 'Not Medical Advice',
      body: 'ZÜVO is a personal health tracker, not a medical service. Always consult a qualified healthcare professional for medical decisions.',
    ),
  ];

  void _openLegalDoc(BuildContext context, String title, String content) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _LegalDocViewer(title: title, content: content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.zyvoTeal.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.policy_outlined, color: AppColors.zyvoTeal, size: 28),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Privacy & Terms',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We care about your privacy. Here is what you need to know before getting started.',
                    style: TextStyle(fontSize: 13, color: Colors.white60, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card with terms content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._termSections.map((t) => _TermCard(
                          icon: t.icon,
                          color: t.color,
                          title: t.title,
                          body: t.body,
                        )),

                        // Read full documents buttons
                        _readDocButton(
                          context,
                          icon: Icons.description_outlined,
                          label: 'Read Terms of Service',
                          borderColor: context.border,
                          textColor: context.textM,
                          onTap: () => _openLegalDoc(context, 'Terms of Service', _termsOfServiceText),
                        ),
                        const SizedBox(height: 8),
                        _readDocButton(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          label: 'Read Privacy Policy',
                          borderColor: context.border,
                          textColor: context.textM,
                          onTap: () => _openLegalDoc(context, 'Privacy Policy', _privacyPolicyText),
                        ),

                        const SizedBox(height: 16),

                        // Agreement checkbox with tappable links
                        GestureDetector(
                          onTap: () => setState(() => _accepted = !_accepted),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: _accepted ? AppColors.zyvoTeal : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _accepted ? AppColors.zyvoTeal : context.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: _accepted
                                    ? const Icon(Icons.check, size: 14, color: AppColors.zyvoNavy)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: const TextStyle(
                                          color: AppColors.zyvoTeal,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _openLegalDoc(context, 'Terms of Service', _termsOfServiceText),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: const TextStyle(
                                          color: AppColors.zyvoTeal,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _openLegalDoc(context, 'Privacy Policy', _privacyPolicyText),
                                      ),
                                      const TextSpan(text: '. I understand that ZÜVO is not a medical service.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _accepted ? widget.onAccept : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.zyvoTeal,
                              foregroundColor: AppColors.zyvoNavy,
                              disabledBackgroundColor: context.border,
                              disabledForegroundColor: context.textM,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              'I Agree & Continue',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readDocButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.zyvoTeal),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textColor),
          ],
        ),
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _TermCard({required this.icon, required this.color, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH)),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(fontSize: 11, color: context.textM, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//  Profile Setup Multi-Step Flow 
class _ProfileSetupFlow extends ConsumerStatefulWidget {
  final Map<String, dynamic> profileData;
  final VoidCallback onComplete;
  const _ProfileSetupFlow({required this.profileData, required this.onComplete});
  @override
  ConsumerState<_ProfileSetupFlow> createState() => _ProfileSetupFlowState();
}

class _ProfileSetupFlowState extends ConsumerState<_ProfileSetupFlow> {
  int _step = 0;
  static const int _totalSteps = 5;
  String? _stepError;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  String _sex = '';
  List<String> _conditions = [];
  late TextEditingController _conditionCtrl;
  List<TextEditingController> _medCtrls = [];
  List<TextEditingController> _allergyCtrls = [];
  String _smoking = '';
  String _alcohol = '';
  String _activity = '';

  static const _conditionSuggestions = [
    'Diabetes', 'Thyroid Disorder', 'Hypertension', 'High Cholesterol',
    'PCOS', 'Asthma', 'Heart Disease',
  ];
  static const _smokingOptions = ['Never', 'Former smoker', 'Occasionally', 'Daily'];
  static const _alcoholOptions = ['Never', 'Occasionally', 'Socially', 'Regularly'];
  static const _activityLevels = ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    _conditionCtrl = TextEditingController();
    _medCtrls = [TextEditingController()];
    _allergyCtrls = [TextEditingController()];
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _dobCtrl.dispose();
    _heightCtrl.dispose(); _weightCtrl.dispose();
    _conditionCtrl.dispose();
    for (final c in _medCtrls) c.dispose();
    for (final c in _allergyCtrls) c.dispose();
    super.dispose();
  }

  double? get _bmi {
    final h = double.tryParse(_heightCtrl.text);
    final w = double.tryParse(_weightCtrl.text);
    if (h == null || w == null || h == 0) return null;
    return w / ((h / 100) * (h / 100));
  }

  String get _bmiCategory {
    final b = _bmi;
    if (b == null) return '';
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    final b = _bmi;
    if (b == null) return AppColors.zyvoTeal;
    if (b < 18.5) return AppColors.infoColor;
    if (b < 25) return AppColors.zyvoTeal;
    if (b < 30) return const Color(0xFFD97706);
    return AppColors.errorAlt;
  }

  int? get _age {
    if (_dobCtrl.text.isEmpty) return null;
    final parts = _dobCtrl.text.split('-');
    if (parts.length != 3) return null;
    final dob = DateTime.tryParse(_dobCtrl.text);
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
    return age;
  }

  /// Returns null if valid, or an error message.
  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty) return 'Please enter your full name';
        if (_emailCtrl.text.trim().isEmpty) return 'Please enter your email address';
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_emailCtrl.text.trim())) {
          return 'Please enter a valid email address';
        }
        if (_dobCtrl.text.isEmpty) return 'Please select your date of birth';
        if (_sex.isEmpty) return 'Please select your biological sex';
        return null;
      case 1:
        if (_heightCtrl.text.trim().isEmpty) return 'Please enter your height';
        if (double.tryParse(_heightCtrl.text) == null) return 'Enter a valid height';
        if (_weightCtrl.text.trim().isEmpty) return 'Please enter your weight';
        if (double.tryParse(_weightCtrl.text) == null) return 'Enter a valid weight';
        return null;
      case 2:
        if (_conditions.isEmpty) return 'Please add at least one condition or tap "None"';
        return null;
      case 4:
        if (_smoking.isEmpty) return 'Please select your smoking status';
        if (_alcohol.isEmpty) return 'Please select your alcohol consumption';
        if (_activity.isEmpty) return 'Please select your activity level';
        return null;
      default:
        return null;
    }
  }

  void _tryAdvance() {
    final error = _validateStep(_step);
    if (error != null) {
      setState(() => _stepError = error);
      return;
    }
    setState(() {
      _stepError = null;
      _step++;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.zyvoTeal, onPrimary: AppColors.zyvoNavy),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, "0")}-${picked.day.toString().padLeft(2, "0")}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _totalSteps) return _buildCompleteScreen();

    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: SafeArea(
        child: Column(
          children: [
            //  Progress header 
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_step > 0)
                        GestureDetector(
                          onTap: () => setState(() => _step--),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 34),
                      Expanded(
                        child: Text(
                          'Step ${_step + 1} of $_totalSteps',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (_step == 3)
                        GestureDetector(
                          onTap: () => setState(() { _stepError = null; _step++; }),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Skip',
                              style: TextStyle(fontSize: 13, color: Colors.white60, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 34),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / _totalSteps,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation(AppColors.zyvoTeal),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            //  Card 
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 32, offset: Offset(0, -4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Column(
                    children: [
                      // Step header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: _buildStepHeader(),
                      ),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: _buildStepContent(),
                        ),
                      ),

                      // Error message
                      if (_stepError != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.errorAlt.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.errorAlt.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: AppColors.errorAlt),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _stepError!,
                                    style: const TextStyle(fontSize: 12, color: AppColors.errorAlt, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Continue button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _tryAdvance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.zyvoTeal,
                              foregroundColor: AppColors.zyvoNavy,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              _step == _totalSteps - 1 ? 'Complete Profile' : 'Continue',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    const icons = [
      Icons.person_outline,
      Icons.monitor_weight_outlined,
      Icons.favorite_border,
      Icons.medication_outlined,
      Icons.directions_run_outlined,
    ];
    const titles = [
      'Basic Information',
      'Body Metrics',
      'Health Conditions',
      'Medications & Allergies',
      'Lifestyle',
    ];
    const subtitles = [
      'Required — tell us about yourself',
      'Required — used to calculate your BMI',
      'Required — personalises your insights',
      'Optional — helps flag interactions',
      'Required — contextualises your data',
    ];

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.zyvoTeal.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icons[_step], size: 20, color: AppColors.zyvoTeal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[_step],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textH),
              ),
              Text(
                subtitles[_step],
                style: TextStyle(fontSize: 12, color: context.textM),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    return [
      _buildBasicInfo(),
      _buildBodyMetrics(),
      _buildConditions(),
      _buildMedicationsAllergies(),
      _buildLifestyle(),
    ][_step];
  }

  // Step 0: Basic Information
  Widget _buildBasicInfo() {
    return Column(
      children: [
        _inputField(label: 'Full Name *', controller: _nameCtrl, hint: 'Your full name'),
        const SizedBox(height: 16),
        _inputField(label: 'Email Address *', controller: _emailCtrl, hint: 'you@example.com', keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: _inputField(
              label: 'Date of Birth *',
              controller: _dobCtrl,
              hint: 'Tap to select',
              suffixIcon: Icons.calendar_today_outlined,
            ),
          ),
        ),
        if (_age != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.zyvoTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Age: $_age years',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.zyvoTeal),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        _sectionLabel('Biological Sex *'),
        const SizedBox(height: 8),
        Row(
          children: ['Male', 'Female', 'Other'].asMap().entries.map((e) {
            final s = e.value;
            final isLast = e.key == 2;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() { _stepError = null; _sex = s; }),
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _sex == s ? AppColors.zyvoTeal : context.surface2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _sex == s ? AppColors.zyvoTeal : context.border),
                  ),
                  child: Text(
                    s,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _sex == s ? AppColors.zyvoNavy : context.textM,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 1: Body Metrics
  Widget _buildBodyMetrics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _inputField(
                label: 'Height (cm) *',
                controller: _heightCtrl,
                hint: '175',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _inputField(
                label: 'Weight (kg) *',
                controller: _weightCtrl,
                hint: '72',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        if (_bmi != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _bmiColor.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _bmiColor.withOpacity(0.25)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BMI Estimate',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textH)),
                    Text(
                      _bmi!.toStringAsFixed(1),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _bmiColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (_bmi! / 40).clamp(0.0, 1.0),
                    backgroundColor: context.border,
                    valueColor: AlwaysStoppedAnimation(_bmiColor),
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _bmiCategory,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _bmiColor),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Step 2: Health Conditions
  bool get _isNone => _conditions.length == 1 && _conditions.first == 'None';

  void _addCondition(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _stepError = null;
      _conditions.remove('None');
      if (!_conditions.contains(trimmed)) _conditions.add(trimmed);
      _conditionCtrl.clear();
    });
  }

  void _removeCondition(String value) {
    setState(() {
      _conditions.remove(value);
      _stepError = null;
    });
  }

  void _toggleNone() {
    setState(() {
      _stepError = null;
      if (_isNone) {
        _conditions.clear();
      } else {
        _conditions = ['None'];
        _conditionCtrl.clear();
      }
    });
  }

  Widget _buildConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick-add suggestions
        _sectionLabel('COMMON CONDITIONS'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _conditionSuggestions
              .where((c) => !_conditions.contains(c))
              .map((c) => GestureDetector(
                    onTap: _isNone ? null : () => _addCondition(c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isNone ? context.surface2.withOpacity(0.5) : context.surface2,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14, color: _isNone ? context.hint : AppColors.zyvoTeal),
                          const SizedBox(width: 4),
                          Text(c, style: TextStyle(fontSize: 12, color: _isNone ? context.hint : context.textM)),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),

        const SizedBox(height: 16),

        // Text input for custom conditions
        _sectionLabel('ADD CONDITION'),
        const SizedBox(height: 8),
        TextField(
          controller: _conditionCtrl,
          enabled: !_isNone,
          style: TextStyle(fontSize: 14, color: context.textH),
          textInputAction: TextInputAction.done,
          onSubmitted: _addCondition,
          decoration: InputDecoration(
            hintText: _isNone ? 'Disabled — "None" selected' : 'Type a condition & press enter',
            hintStyle: TextStyle(fontSize: 13, color: context.hint),
            filled: true,
            fillColor: _isNone ? context.surface2.withOpacity(0.5) : context.surface2,
            suffixIcon: !_isNone
                ? IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.zyvoTeal, size: 20),
                    onPressed: () => _addCondition(_conditionCtrl.text),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: context.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: context.border)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: context.border.withOpacity(0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.zyvoTeal, width: 1.5)),
          ),
        ),

        const SizedBox(height: 16),

        // Selected conditions as removable bubbles
        if (_conditions.isNotEmpty && !_isNone) ...[        
          _sectionLabel('YOUR CONDITIONS'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _conditions.map((c) => Container(
              padding: const EdgeInsets.only(left: 14, right: 6, top: 7, bottom: 7),
              decoration: BoxDecoration(
                color: AppColors.zyvoTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.zyvoTeal.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.zyvoTeal)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _removeCondition(c),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.zyvoTeal.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 12, color: AppColors.zyvoTeal),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // "None" toggle
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _toggleNone,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _isNone ? AppColors.zyvoTeal : context.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _isNone ? AppColors.zyvoTeal : context.border),
            ),
            child: Row(
              children: [
                Icon(
                  _isNone ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: _isNone ? AppColors.zyvoNavy : context.textM,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No known health conditions',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _isNone ? AppColors.zyvoNavy : context.textM,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Step 3: Medications & Allergies
  Widget _buildMedicationsAllergies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('CURRENT MEDICATIONS'),
        const SizedBox(height: 8),
        ...List.generate(
          _medCtrls.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _inputField(label: '', controller: _medCtrls[i], hint: 'e.g. Atorvastatin 10mg'),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _medCtrls.add(TextEditingController())),
          child: const Text('+ Add medication',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.zyvoTeal)),
        ),
        const SizedBox(height: 20),
        _sectionLabel('ALLERGIES'),
        const SizedBox(height: 8),
        ...List.generate(
          _allergyCtrls.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _inputField(label: '', controller: _allergyCtrls[i], hint: 'e.g. Penicillin'),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _allergyCtrls.add(TextEditingController())),
          child: const Text('+ Add allergy',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.zyvoTeal)),
        ),
      ],
    );
  }

  // Step 4: Lifestyle
  Widget _buildLifestyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleGroup(label: 'Smoking Status *', options: _smokingOptions, value: _smoking, onChanged: (v) => setState(() { _stepError = null; _smoking = v; }), cols: 2),
        const SizedBox(height: 20),
        _buildToggleGroup(label: 'Alcohol Consumption *', options: _alcoholOptions, value: _alcohol, onChanged: (v) => setState(() { _stepError = null; _alcohol = v; }), cols: 2),
        const SizedBox(height: 20),
        _sectionLabel('Activity Level *'),
        const SizedBox(height: 8),
        ..._activityLevels.map((opt) => GestureDetector(
          onTap: () => setState(() { _stepError = null; _activity = opt; }),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: _activity == opt ? AppColors.zyvoTeal : context.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _activity == opt ? AppColors.zyvoTeal : context.border),
            ),
            child: Text(
              opt,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                color: _activity == opt ? AppColors.zyvoNavy : context.textM),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildToggleGroup({
    required String label,
    required List<String> options,
    required String value,
    required void Function(String) onChanged,
    required int cols,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3,
          children: options.map((opt) => GestureDetector(
            onTap: () => onChanged(opt),
            child: Container(
              decoration: BoxDecoration(
                color: value == opt ? AppColors.zyvoTeal : context.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: value == opt ? AppColors.zyvoTeal : context.border),
              ),
              child: Center(
                child: Text(
                  opt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: value == opt ? AppColors.zyvoNavy : context.textM,
                  ),
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  // Complete screen
  Widget _buildCompleteScreen() {
    final activeMeds = _medCtrls.where((c) => c.text.trim().isNotEmpty).length;
    int activeConditions = _conditions.where((c) => c != 'None').length;

    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 40, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.zyvoTeal.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_outline, size: 40, color: AppColors.zyvoTeal),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your health profile is ready!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textH),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ZÜVO is personalised and ready. Upload your first report to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    children: [
                      Expanded(child: _statCard(label: 'BMI', value: _bmi?.toStringAsFixed(1) ?? '--', sub: _bmiCategory.isEmpty ? 'Not set' : _bmiCategory)),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard(label: 'Conditions', value: activeConditions == 0 ? '--' : '$activeConditions', sub: 'tracked')),
                      const SizedBox(width: 8),
                      Expanded(child: _statCard(label: 'Medications', value: activeMeds == 0 ? '--' : '$activeMeds', sub: 'recorded')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(userProfileProvider.notifier).update(UserProfile(
                          name: _nameCtrl.text.trim(),
                          email: _emailCtrl.text.trim(),
                          dob: _dobCtrl.text,
                          sex: _sex,
                          height: _heightCtrl.text.trim(),
                          weight: _weightCtrl.text.trim(),
                          bmi: _bmi,
                          conditions: List<String>.from(_conditions),
                          medications: _medCtrls.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
                          allergies: _allergyCtrls.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
                          smoking: _smoking,
                          alcohol: _alcohol,
                          activity: _activity,
                        ));
                        widget.onComplete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.zyvoTeal,
                        foregroundColor: AppColors.zyvoNavy,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Continue to Dashboard',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _statCard({required String label, required String value, required String sub}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.zyvoTeal.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.zyvoTeal.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.zyvoTeal)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: context.textH)),
          Text(sub, style: TextStyle(fontSize: 9, color: context.textM)),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textM, letterSpacing: 0.4),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: context.textM)),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14, color: context.textH),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: context.hint),
            filled: true,
            fillColor: context.surface2,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: context.textM)
                : null,
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
          ),
          onChanged: (_) => setState(() { _stepError = null; }),
        ),
      ],
    );
  }
}

// ─── Full-text legal document viewer ─────────────────────────────────────────

class _LegalDocViewer extends StatelessWidget {
  final String title;
  final String content;
  const _LegalDocViewer({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zyvoNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Content card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                    child: _buildFormattedContent(context, content),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedContent(BuildContext context, String content) {
    final lines = content.split('\n');
    final children = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 6));
      } else if (trimmed.startsWith('---')) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: context.textM.withOpacity(0.25), height: 1),
        ));
      } else if (RegExp(r'^\d+\.\s').hasMatch(trimmed) && !trimmed.contains(':') || trimmed.startsWith('ZÜVO –') || trimmed.startsWith('IMPORTANT')) {
        // Section heading
        children.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            trimmed,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.textH, height: 1.5),
          ),
        ));
      } else if (RegExp(r'^\d+\.\d+\s').hasMatch(trimmed)) {
        // Sub-heading (2.1, 2.2, etc.)
        children.add(Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 2),
          child: Text(
            trimmed,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH, height: 1.5),
          ),
        ));
      } else if (trimmed.startsWith('- ') || trimmed.startsWith('• ')) {
        // Bullet point
        children.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•  ', style: TextStyle(fontSize: 13, color: AppColors.zyvoTeal, fontWeight: FontWeight.w700)),
              Expanded(
                child: Text(
                  trimmed.substring(2),
                  style: TextStyle(fontSize: 13, color: context.textM, height: 1.6),
                ),
              ),
            ],
          ),
        ));
      } else if (trimmed.startsWith('👉')) {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 2),
          child: Text(trimmed, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH, height: 1.5)),
        ));
      } else if (trimmed.startsWith('Last Updated:') || trimmed.startsWith('Email:') || trimmed.startsWith('Support:') || trimmed.startsWith('Grievance')) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(trimmed, style: TextStyle(fontSize: 12, color: context.textM, fontStyle: FontStyle.italic, height: 1.5)),
        ));
      } else {
        // Regular paragraph
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            trimmed,
            style: TextStyle(fontSize: 13, color: context.textM, height: 1.6),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// ─── Legal content strings ───────────────────────────────────────────────────

const _termsOfServiceText = '''ZÜVO – Terms of Service

Last Updated: 22 March 2026

Welcome to ZÜVO. These Terms of Service ("Terms") govern your use of the ZÜVO mobile application and related services ("Service", "App", "we", "us", or "our").

By accessing or using ZÜVO, you agree to these Terms. If you do not agree, please do not use the Service.

---

1. What ZÜVO Does

ZÜVO is a health-tech platform that allows you to:

- Store and organize your medical records
- Extract and view health parameters from reports
- Track trends in your health data
- Generate summaries to help you prepare for doctor visits
- Receive general health reminders

ZÜVO is designed to help you better understand your health information.

---

2. IMPORTANT MEDICAL DISCLAIMER

ZÜVO does not provide medical advice.

- We do not diagnose, treat, or prevent any disease
- Any insights or trends shown are for informational purposes only
- Always consult a qualified healthcare professional for medical decisions

You agree that:

- You will not rely solely on ZÜVO for medical decisions
- ZÜVO is not a substitute for professional medical advice

---

3. Eligibility

To use ZÜVO, you must:

- Be at least 18 years old (or have parental/guardian consent)
- Provide accurate information
- Use the app lawfully

---

4. Your Account

You are responsible for:

- Keeping your login credentials secure
- All activity under your account

You agree not to:

- Share your account
- Use another person's account
- Misuse the platform

---

5. Your Data

You may upload:

- Medical reports
- Images and scans
- Health information (age, weight, conditions, etc.)

You confirm that:

- You have the right to upload this data
- The data you provide is accurate to the best of your knowledge

---

6. How We Use Your Data

We use your data to:

- Store and organize your records
- Extract structured information from reports
- Generate trends and summaries
- Improve the Service

We do not sell your personal health data.

For more details, see our Privacy Policy.

---

7. AI-Generated Insights

ZÜVO uses automated systems (including AI) to:

- Extract data from documents
- Generate trends and summaries

You understand and agree that:

- These outputs may not always be accurate
- You should verify important information
- You should consult a doctor before taking action

---

8. User Responsibility

You are responsible for:

- Reviewing extracted data for accuracy
- Verifying important medical information
- Using the app responsibly

ZÜVO is not responsible for:

- Errors in uploaded reports
- Incorrect interpretation of insights
- Decisions made based on app content

---

9. Data Storage & Security

We take reasonable measures to protect your data, including:

- Encryption
- Secure storage systems
- Access controls

However, no system is completely secure. By using ZÜVO, you acknowledge this risk.

---

10. Data Deletion & Control

You have the right to:

- Access your data
- Edit your data
- Delete your account and data

When you delete your account:

- Your data will be permanently removed (subject to legal requirements)

---

11. Prohibited Use

You agree NOT to:

- Use the app for illegal purposes
- Upload harmful, false, or misleading data
- Attempt to hack or disrupt the service
- Reverse engineer or copy the platform

---

12. Third-Party Services

ZÜVO may use third-party services (e.g., cloud storage, AI processing).

We are not responsible for:

- Failures of third-party services
- External system errors

---

13. Limitation of Liability

To the maximum extent permitted by law:

ZÜVO is not liable for:

- Medical decisions made using the app
- Any indirect or consequential damages
- Data loss due to unforeseen issues

Your use of the app is at your own risk.

---

14. Indemnification

You agree to indemnify and hold ZÜVO harmless from:

- Claims arising from your use of the app
- Violations of these Terms
- Misuse of the platform

---

15. Service Availability

We may:

- Modify or discontinue features
- Perform maintenance
- Update the app

We do not guarantee uninterrupted service.

---

16. Changes to Terms

We may update these Terms from time to time.

If we do:

- We will notify you
- Continued use means you accept the changes

---

17. Governing Law

These Terms are governed by the laws of India.

Any disputes will be subject to the jurisdiction of Indian courts.

---

18. Contact Us

If you have questions, contact:

Email: [Insert Email]
Support: [Insert Support Link]

---

19. Final Note

ZÜVO is built to help you better understand your health.

But your health decisions should always involve a qualified medical professional.''';

const _privacyPolicyText = '''ZÜVO – Privacy Policy

Last Updated: 22 March 2026

ZÜVO ("we", "us", "our") respects your privacy and is committed to protecting your personal data.

This Privacy Policy explains how we collect, use, store, and protect your information when you use the ZÜVO mobile application and services ("Service").

By using ZÜVO, you agree to the terms of this Privacy Policy.

---

1. Overview

ZÜVO is a health-tech platform that allows you to store medical records, extract health data, track trends, and generate summaries.

We handle personal data, including health-related information, with a high level of care and responsibility.

---

2. Data We Collect

2.1 Personal Information

When you use ZÜVO, we may collect:

- Name
- Email address
- Phone number (if provided)
- Login credentials

---

2.2 Health Information (Sensitive Data)

You may provide:

- Medical reports (PDFs, images, scans)
- Lab results and health parameters
- Health profile details:
  - age
  - gender
  - height, weight
  - conditions
  - medications
  - allergies

This is considered sensitive personal data.

---

2.3 Usage Data

We may collect:

- App usage behavior
- Device information
- Log data (for performance and debugging)

---

3. How We Use Your Data

We use your data only for the following purposes:

- To store and organize your medical records
- To extract structured information from your reports
- To generate health trends and summaries
- To provide reminders and insights
- To improve app performance and user experience
- To provide support and respond to queries

We do NOT sell your personal or health data.

---

4. Legal Basis for Processing (DPDP Compliance)

We process your data based on:

👉 Your explicit consent

You provide consent when you:

- Sign up for ZÜVO
- Upload data
- Use app features

You may withdraw consent at any time.

---

5. Data Minimization

We only collect data that is:

- necessary for the Service
- relevant to your health tracking and analysis

We do not collect unnecessary personal information.

---

6. Data Storage & Security

We use reasonable security measures to protect your data, including:

- Encryption (in transit and at rest)
- Secure cloud storage
- Access controls and authentication
- Monitoring and logging

However, no system is completely secure, and we cannot guarantee absolute security.

---

7. Data Retention

We retain your data:

- As long as your account is active
- As required to provide services
- As required by applicable law

When you delete your account:

- Your data will be deleted or anonymized, subject to legal requirements

---

8. Your Rights (Under DPDP Act)

You have the right to:

- Access your data
- Correct inaccurate data
- Delete your data
- Withdraw consent
- Request details about how your data is used

You can exercise these rights through the app or by contacting us.

---

9. Data Sharing

We do not sell or rent your data.

We may share data only in the following cases:

9.1 Service Providers

With trusted third parties (e.g., cloud providers, AI services) strictly for:

- data processing
- storage
- service functionality

These parties are required to maintain confidentiality and security.

---

9.2 Legal Requirements

If required by law or government authority, we may disclose data.

---

10. AI & Automated Processing

ZÜVO uses automated systems (including AI) to:

- extract data from reports
- generate summaries and insights

You acknowledge that:

- outputs may not always be accurate
- these are for informational purposes only

---

11. Data Deletion

You can:

- delete specific data
- delete your account

Upon deletion:

- we will remove your personal data from our systems (subject to legal obligations)

---

12. Children's Privacy

ZÜVO is not intended for children under 18 without parental consent.

We do not knowingly collect data from children without appropriate authorization.

---

13. Cross-Border Data Transfer

Your data may be processed or stored outside India using secure infrastructure.

We ensure appropriate safeguards are in place.

---

14. Cookies & Tracking

We may use limited tracking technologies to:

- improve app performance
- understand usage patterns

We do not use tracking for advertising purposes.

---

15. Changes to This Policy

We may update this Privacy Policy from time to time.

If changes are significant:

- we will notify you

Continued use of the app means acceptance of the updated policy.

---

16. Grievance Officer (DPDP Requirement)

If you have concerns regarding your data, contact:

Grievance Officer: [Insert Name]
Email: [Insert Email]

We will address your concerns as per applicable law.

---

17. Contact Us

For any questions or requests:

Email: [Insert Email]
Support: [Insert Link]

---

18. Final Note

Your health data is sensitive and important.

ZÜVO is committed to handling it responsibly, transparently, and securely, in accordance with Indian data protection laws.''';
