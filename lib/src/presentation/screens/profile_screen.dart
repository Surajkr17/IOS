import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/providers/user_profile_provider.dart';
import 'package:health_trace/src/presentation/widgets/app_bottom_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _expandedSection;
  bool _showDeleteConfirm = false;

  void _toggleSection(String id) =>
      setState(() => _expandedSection = _expandedSection == id ? null : id);

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final hasProfile = profile.name.isNotEmpty;

    return Scaffold(
      backgroundColor: context.bg,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Profile',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: context.textH)),
                      ),
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: context.surface, borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: context.border),
                        ),
                        child: Icon(Icons.settings_outlined, size: 16, color: context.textM),
                      ),
                    ],
                  ),
                ),

                // Avatar card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.surface, borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                              colors: [AppColors.avatarBlue, AppColors.avatarBlueLight],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hasProfile ? profile.name : 'Your Name',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textH)),
                              const SizedBox(height: 2),
                              Text(hasProfile ? profile.email : 'your@email.com',
                                style: TextStyle(fontSize: 12, color: context.textM)),
                              if (!hasProfile) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningBg, borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Complete Profile',
                                    style: TextStyle(fontSize: 10, color: AppColors.warningColor,
                                      fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(color: context.bg, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.edit_outlined, size: 15, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _statCard('BMI',
                        profile.bmi?.toStringAsFixed(1) ?? '--',
                        profile.bmiCategory.isEmpty ? 'Not set' : profile.bmiCategory),
                      const SizedBox(width: 8),
                      _statCard('Reports', '0', 'uploaded'),
                      const SizedBox(width: 8),
                      _statCard('Conditions',
                        profile.conditions.where((c) => c != 'None').isEmpty ? '0'
                          : '${profile.conditions.where((c) => c != "None").length}',
                        'tracked'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Health Profile section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CollapsibleSection(
                    id: 'health', title: 'Health Profile',
                    iconData: Icons.favorite_border, iconColor: AppColors.errorColor,
                    expanded: _expandedSection == 'health',
                    onToggle: () => _toggleSection('health'),
                    child: Column(
                      children: [
                        _infoRow('Age / Sex',
                          '${profile.age ?? "--"} / ${profile.sex.isEmpty ? "--" : profile.sex}'),
                        _infoRow('Height / Weight',
                          '${profile.height.isEmpty ? "--" : profile.height} cm  ${profile.weight.isEmpty ? "--" : profile.weight} kg'),
                        _infoRow('BMI',
                          profile.bmi?.toStringAsFixed(1) ?? '--'),
                        _infoRow('Blood Group', '--'),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('CONDITIONS',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: context.textM, letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: profile.conditions.isEmpty || (profile.conditions.length == 1 && profile.conditions.first == 'None')
                            ? Text('None specified', style: TextStyle(fontSize: 12, color: context.textL))
                            : Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: profile.conditions.where((c) => c != 'None').map((c) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(c, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primaryColor)),
                                )).toList(),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Medications section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CollapsibleSection(
                    id: 'meds', title: 'Medications & Allergies',
                    iconData: Icons.medication_outlined, iconColor: AppColors.accentPurple,
                    expanded: _expandedSection == 'meds',
                    onToggle: () => _toggleSection('meds'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MEDICATIONS',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: context.textM, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        profile.medications.isEmpty
                          ? Text('None specified', style: TextStyle(fontSize: 12, color: context.textL))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: profile.medications.map((m) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text('• $m', style: TextStyle(fontSize: 12, color: context.textH)),
                                ),
                              ).toList(),
                            ),
                        const SizedBox(height: 12),
                        Text('ALLERGIES',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: context.textM, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        profile.allergies.isEmpty
                          ? Text('None specified', style: TextStyle(fontSize: 12, color: context.textL))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: profile.allergies.map((a) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text('• $a', style: TextStyle(fontSize: 12, color: context.textH)),
                                ),
                              ).toList(),
                            ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Lifestyle section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CollapsibleSection(
                    id: 'lifestyle', title: 'Lifestyle',
                    iconData: Icons.directions_run_outlined, iconColor: AppColors.successColor,
                    expanded: _expandedSection == 'lifestyle',
                    onToggle: () => _toggleSection('lifestyle'),
                    child: Column(
                      children: [
                        _infoRow('Smoking',
                          profile.smoking.isEmpty ? '--' : profile.smoking),
                        _infoRow('Alcohol',
                          profile.alcohol.isEmpty ? '--' : profile.alcohol),
                        _infoRow('Activity',
                          profile.activity.isEmpty ? '--' : profile.activity),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Preferences
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('PREFERENCES',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: context.textM, letterSpacing: 0.6)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surface, borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.border),
                        ),
                        child: Column(
                          children: [
                            // Dark mode info row (display only — system-controlled)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Icon(
                                    context.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                                    size: 16, color: context.textM,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text('Dark Mode',
                                      style: TextStyle(fontSize: 14, color: context.textH)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: context.isDark ? AppColors.primaryColor.withOpacity(0.15) : AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      context.isDark ? 'On' : 'Off',
                                      style: TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w600,
                                        color: context.isDark ? AppColors.primaryColor : context.textM,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: context.divider),
                            _settingsRow(Icons.notifications_outlined, 'Notifications', 'Report alerts'),
                            Divider(height: 1, color: context.divider),
                            _settingsRow(Icons.lock_outline, 'Privacy Settings', 'Data sharing'),
                            Divider(height: 1, color: context.divider),
                            _settingsRow(Icons.download_outlined, 'Export Health Data', 'Download all reports'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Legal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('LEGAL',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: context.textM, letterSpacing: 0.6)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surface, borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.border),
                        ),
                        child: Column(
                          children: [
                            _legalRow(Icons.description_outlined, 'Terms of Service'),
                            Divider(height: 1, color: context.divider),
                            _legalRow(Icons.shield_outlined, 'Privacy Policy'),
                            Divider(height: 1, color: context.divider),
                            _legalRow(Icons.warning_amber_outlined, 'Medical Disclaimer'),
                            Divider(height: 1, color: context.divider),
                            _legalRow(Icons.help_outline, 'Help & Support'),
                            Divider(height: 1, color: context.divider),
                            _legalRow(Icons.star_border, 'Rate ZÜVO'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Disclaimer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 13, color: AppColors.warningColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ZÜVO is a personal health record tool. It does not provide medical diagnoses or treatment. Always consult a qualified healthcare professional for medical decisions.',
                            style: TextStyle(fontSize: 11, color: AppColors.warningColor, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Account actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _actionButton(Icons.logout, 'Sign Out', context.textM, () {}),
                      const SizedBox(height: 8),
                      _actionButton(Icons.delete_outline, 'Delete Account',
                        AppColors.errorColor, () => setState(() => _showDeleteConfirm = true)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_showDeleteConfirm) _buildDeleteDialog(),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  Widget _statCard(String label, String value, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: context.surface, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.border),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
              color: AppColors.primaryColor)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: context.textM)),
            Text(sub, style: TextStyle(fontSize: 9, color: context.textL)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: context.textM)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textH)),
        ],
      ),
    );
  }

  Widget _settingsRow(IconData icon, String label, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.textM),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: context.textH)),
                Text(sub, style: TextStyle(fontSize: 11, color: context.textM)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 14, color: context.textL),
        ],
      ),
    );
  }

  Widget _legalRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 15, color: context.textM),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: context.textH))),
          Icon(Icons.chevron_right, size: 14, color: context.textL),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.surface, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: context.surface, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: const BoxDecoration(color: AppColors.errorBg, shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, size: 28, color: AppColors.errorColor),
                ),
                const SizedBox(height: 16),
                Text('Delete Account?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: context.textH)),
                const SizedBox(height: 8),
                Text(
                  'This will permanently delete all your reports and health data. This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setState(() => _showDeleteConfirm = false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: context.border),
                          ),
                        ),
                        child: Text('Cancel', style: TextStyle(color: context.textM)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  Collapsible Section 
class _CollapsibleSection extends StatelessWidget {
  final String id, title;
  final IconData iconData;
  final Color iconColor;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const _CollapsibleSection({
    required this.id, required this.title,
    required this.iconData, required this.iconColor,
    required this.expanded, required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(iconData, size: 16, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textH)),
                  ),
                  Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18, color: context.textM,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: expanded
                ? Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: child)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
