import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/core/constants/app_strings.dart';
import 'package:health_trace/src/presentation/widgets/app_bottom_nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // For a new user there are no reports yet — simulate that here.
  // Once a backend is added, replace this with a real data provider.
  final bool _hasReports = false;

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: context.bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(greeting: greeting),
            const SizedBox(height: 20),

            _hasReports
                ? _buildOverviewCard()
                : _buildEmptyHeroBanner(),

            const SizedBox(height: 24),
            _buildQuickActionsRow(),
            const SizedBox(height: 24),
            _buildRecentReportsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  //  Header 
  Widget _buildHeader({
    required String greeting,
  }) {
    return Container(
      color: context.bg,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting + name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting,',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textM)),
              const SizedBox(height: 2),
              Text(AppStrings.appName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: context.textH)),
            ],
          ),

          // Actions
          Row(
            children: [
              // Notification bell
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: context.cardBg,
                  border: Border.all(color: context.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.notifications_outlined, size: 18, color: context.textM),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.zyvoTeal, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('U',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.zyvoNavy)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Empty hero banner (new user, no reports) 
  Widget _buildEmptyHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.zyvoNavy, AppColors.darkNavyGradientEnd],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x40000000), blurRadius: 24, offset: Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.zyvoTeal.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -10,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.zyvoPurple.withOpacity(0.07),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.zyvoTeal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.health_and_safety_outlined, color: AppColors.zyvoTeal, size: 24),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your health journey\nstarts here',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload your first medical report and let ZÜVO extract and track your health data automatically.',
                  style: TextStyle(fontSize: 13, color: Colors.white60, height: 1.5),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: const Text('Upload First Report',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zyvoTeal,
                    foregroundColor: AppColors.zyvoNavy,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //  Overview card (has reports) 
  Widget _buildOverviewCard() {
    const normalCount = 12, cautionCount = 3, abnormalCount = 2;
    const total = normalCount + cautionCount + abnormalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.zyvoNavy, AppColors.darkNavyGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Health Overview',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.zyvoTeal.withOpacity(0.9))),
                    const SizedBox(height: 2),
                    const Text('Based on $total parameters',
                      style: TextStyle(fontSize: 11, color: Colors.white60)),
                  ],
                ),
                const Icon(Icons.favorite, size: 18, color: AppColors.zyvoTeal),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _healthMetric('Normal',   normalCount,   Colors.green),
                _healthMetric('Caution',  cautionCount,  Colors.amber),
                _healthMetric('Abnormal', abnormalCount, Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  Expanded(flex: normalCount,   child: Container(height: 7, color: Colors.green)),
                  Expanded(flex: cautionCount,  child: Container(height: 7, color: Colors.amber)),
                  Expanded(flex: abnormalCount, child: Container(height: 7, color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthMetric(String label, int count, MaterialColor color) {
    return Column(
      children: [
        Text('$count',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: color.shade300)),
      ],
    );
  }

  //  Quick actions row 
  Widget _buildQuickActionsRow() {
    final actions = [
      (icon: Icons.upload_file_outlined, label: 'Upload', color: AppColors.zyvoTeal),
      (icon: Icons.trending_up,          label: 'Trends',  color: AppColors.zyvoPurple),
      (icon: Icons.medical_services_outlined, label: 'Doctor', color: AppColors.zyvoLime),
      (icon: Icons.person_outline,       label: 'Profile',  color: AppColors.accentOrange),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: actions.map((a) {
          return Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  border: Border.all(color: context.border),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(a.icon, size: 22, color: a.color),
                    const SizedBox(height: 6),
                    Text(a.label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: context.textM)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //  Recent reports section 
  Widget _buildRecentReportsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Reports',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textH)),
              if (_hasReports)
                TextButton(
                  onPressed: () {},
                  child: const Text('View all',
                    style: TextStyle(fontSize: 12, color: AppColors.zyvoTeal, fontWeight: FontWeight.w500)),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (!_hasReports)
            // Empty state card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: context.cardBg,
                border: Border.all(color: context.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.zyvoTeal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.file_present_outlined, size: 28, color: AppColors.zyvoTeal),
                  ),
                  const SizedBox(height: 14),
                  Text('No reports yet',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textH)),
                  const SizedBox(height: 6),
                  Text(
                    'Upload your first medical report to\nget started with ZÜVO.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                    label: const Text('Upload Report',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.zyvoTeal,
                      foregroundColor: AppColors.zyvoNavy,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
