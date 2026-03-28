import 'package:flutter/material.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/widgets/app_bottom_nav.dart';

//  Doctor types 
class _DoctorType {
  final String id, label, desc;
  final IconData icon;
  final Color color;
  const _DoctorType({required this.id, required this.label, required this.icon,
    required this.desc, required this.color});
}

const _doctorTypes = [
  _DoctorType(id: 'general', label: 'General Physician', icon: Icons.person_outline,
    desc: 'Routine health checks, common conditions', color: AppColors.avatarBlue),
  _DoctorType(id: 'cardio', label: 'Cardiologist', icon: Icons.favorite_border,
    desc: 'Heart health, blood pressure, cholesterol', color: AppColors.errorColor),
  _DoctorType(id: 'endo', label: 'Endocrinologist', icon: Icons.science_outlined,
    desc: 'Thyroid, diabetes, hormonal disorders', color: AppColors.accentPurple),
  _DoctorType(id: 'gastro', label: 'Gastroenterologist', icon: Icons.medical_information_outlined,
    desc: 'Digestive health, liver function', color: AppColors.successColor),
  _DoctorType(id: 'onco', label: 'Oncologist', icon: Icons.psychology_outlined,
    desc: 'Cancer screening, oncology follow-ups', color: AppColors.warningColor),
];

class _VisitPurpose {
  final String id, label, desc;
  final IconData icon;
  const _VisitPurpose({required this.id, required this.label,
    required this.desc, required this.icon});
}

const _visitPurposes = [
  _VisitPurpose(id: 'routine', label: 'Routine Check-up',
    desc: 'Annual wellness visit', icon: Icons.assignment_outlined),
  _VisitPurpose(id: 'followup', label: 'Follow-up Visit',
    desc: 'Monitoring existing condition', icon: Icons.access_time_outlined),
  _VisitPurpose(id: 'symptoms', label: 'New Symptoms',
    desc: 'Discussing new health concerns', icon: Icons.warning_amber_outlined),
  _VisitPurpose(id: 'opinion', label: 'Second Opinion',
    desc: "Getting another doctor's view", icon: Icons.person_search_outlined),
];

enum _WizardStep { doctorType, purpose, summary }

//  Screen 
class DoctorVisitScreen extends StatefulWidget {
  const DoctorVisitScreen({super.key});

  @override
  State<DoctorVisitScreen> createState() => _DoctorVisitScreenState();
}

class _DoctorVisitScreenState extends State<DoctorVisitScreen> {
  _WizardStep _step = _WizardStep.doctorType;
  String _selectedDoctor = '', _selectedPurpose = '';
  final _symptomsCtrl = TextEditingController();
  final _chatCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<Map<String, String>> _chatMessages = [
    {'role': 'assistant', 'content':
      'Your medical summary is ready. You can refine it by asking me to add or remove items. Try: "Add my last MRI" or "Remove cholesterol data".'},
  ];

  final _steps = [_WizardStep.doctorType, _WizardStep.purpose, _WizardStep.summary];

  @override
  void dispose() {
    _symptomsCtrl.dispose(); _chatCtrl.dispose(); _scrollCtrl.dispose();
    super.dispose();
  }

  int get _stepIndex => _steps.indexOf(_step);

  void _goNext() {
    if (_step == _WizardStep.doctorType) {
      setState(() => _step = _WizardStep.purpose);
    } else if (_step == _WizardStep.purpose) setState(() => _step = _WizardStep.summary);
  }

  void _goBack() {
    if (_step == _WizardStep.purpose) {
      setState(() => _step = _WizardStep.doctorType);
    } else if (_step == _WizardStep.summary) setState(() => _step = _WizardStep.purpose);
  }

  void _sendChat() {
    final text = _chatCtrl.text.trim();
    if (text.isEmpty) return;
    final lower = text.toLowerCase();
    String reply;
    if (lower.contains('mri')) {
      reply = ' Added MRI report to your summary.';
    } else if (lower.contains('remove')) reply = ' Done. Removed that item from your summary.';
    else if (lower.contains('simplify')) reply = ' Summary simplified to key findings only.';
    else reply = "I've updated your summary accordingly.";

    setState(() {
      _chatMessages.add({'role': 'user', 'content': text});
      _chatMessages.add({'role': 'assistant', 'content': reply});
      _chatCtrl.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildStepContent(),
              ),
            ),
            if (_step != _WizardStep.summary) _buildNextButton(),
            if (_step == _WizardStep.summary) _buildSummaryFooter(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _goBack,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: context.surface, borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.border),
                  ),
                  child: Icon(Icons.arrow_back, size: 16, color: context.textH),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Doctor Visit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
                  Text('Prepare your medical summary',
                    style: TextStyle(fontSize: 11, color: context.textM)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_steps.length, (i) => Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i < _steps.length - 1 ? 6 : 0),
                decoration: BoxDecoration(
                  color: i <= _stepIndex ? AppColors.primaryColor : context.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case _WizardStep.doctorType:
        return _buildDoctorTypeStep();
      case _WizardStep.purpose:
        return _buildPurposeStep();
      case _WizardStep.summary:
        return _buildSummaryStep();
    }
  }

  Widget _buildDoctorTypeStep() {
    return SingleChildScrollView(
      key: const ValueKey('doctor'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Doctor Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.textH)),
          const SizedBox(height: 4),
          Text("Choose the specialist you're visiting",
            style: TextStyle(fontSize: 13, color: context.textM)),
          const SizedBox(height: 16),
          ..._doctorTypes.map((doc) {
            final selected = _selectedDoctor == doc.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedDoctor = doc.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? doc.color.withOpacity(0.06) : context.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? doc.color : context.border, width: selected ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: doc.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                      child: Icon(doc.icon, size: 22, color: doc.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.label,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textH)),
                          Text(doc.desc, style: TextStyle(fontSize: 11, color: context.textM)),
                        ],
                      ),
                    ),
                    if (selected)
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: doc.color, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPurposeStep() {
    return SingleChildScrollView(
      key: const ValueKey('purpose'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Purpose of Visit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.textH)),
          const SizedBox(height: 4),
          Text('What is the reason for this visit?', style: TextStyle(fontSize: 13, color: context.textM)),
          const SizedBox(height: 16),
          ..._visitPurposes.map((p) {
            final selected = _selectedPurpose == p.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedPurpose = p.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryColor.withOpacity(0.06) : context.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.primaryColor : context.border,
                    width: selected ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: selected ? context.primBg : context.bg, borderRadius: BorderRadius.circular(14)),
                      child: Icon(p.icon, size: 20,
                        color: selected ? AppColors.primaryColor : context.textM),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.label,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textH)),
                          Text(p.desc, style: TextStyle(fontSize: 11, color: context.textM)),
                        ],
                      ),
                    ),
                    if (selected)
                      Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Text('Additional Notes',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH)),
          const SizedBox(height: 8),
          TextField(
            controller: _symptomsCtrl,
            maxLines: 3,
            style: TextStyle(fontSize: 13, color: context.textH),
            decoration: InputDecoration(
              hintText: 'Describe your symptoms or concerns...',
              hintStyle: TextStyle(fontSize: 13, color: context.textM),
              filled: true, fillColor: context.surface,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    final doctorInfo  = _selectedDoctor.isNotEmpty
        ? _doctorTypes.firstWhere((d) => d.id == _selectedDoctor) : null;
    final purposeInfo = _selectedPurpose.isNotEmpty
        ? _visitPurposes.firstWhere((p) => p.id == _selectedPurpose) : null;

    return Column(
      key: const ValueKey('summary'),
      children: [
        Expanded(
          child: ListView(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surface, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: context.primBg, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.description_outlined, size: 18,
                            color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorInfo != null
                                    ? '${doctorInfo.label} Summary' : 'Medical Summary',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textH),
                              ),
                              if (purposeInfo != null)
                                Text(purposeInfo.label, style: TextStyle(fontSize: 11, color: context.textM)),
                            ],
                          ),
                        ),
                        const Icon(Icons.share_outlined, size: 16, color: AppColors.primaryColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.upload_file_outlined, size: 16, color: AppColors.warningColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Upload reports to make your summary more complete. Your doctor will see more insights.',
                              style: TextStyle(fontSize: 12, color: AppColors.warningColor, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_symptomsCtrl.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text('YOUR NOTES',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                          color: context.textM, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      Text(_symptomsCtrl.text,
                        style: TextStyle(fontSize: 13, color: context.textH, height: 1.5)),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryColor),
                  SizedBox(width: 6),
                  Text('Refine with AI',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor)),
                ],
              ),
              const SizedBox(height: 10),
              ..._chatMessages.map((msg) => _buildChatBubble(msg)),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // Chat input
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: context.surface,
            border: Border(top: BorderSide(color: context.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatCtrl,
                  style: TextStyle(fontSize: 13, color: context.textH),
                  decoration: InputDecoration(
                    hintText: 'Ask me to add or remove items...',
                    hintStyle: TextStyle(fontSize: 13, color: context.textM),
                    filled: true, fillColor: context.bg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _sendChat(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendChat,
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor, shape: BoxShape.circle),
                  child: const Icon(Icons.send, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primaryColor : context.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isUser ? null : Border.all(color: context.border),
            ),
            child: Text(
              msg['content'] ?? '',
              style: TextStyle(fontSize: 13,
                color: isUser ? Colors.white : context.textH, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final canProceed = _step == _WizardStep.doctorType
        ? _selectedDoctor.isNotEmpty : _selectedPurpose.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canProceed ? _goNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: context.border,
            disabledForegroundColor: context.textM,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Text(
            _step == _WizardStep.purpose ? 'Generate Summary' : 'Continue',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(color: context.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, size: 16),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
