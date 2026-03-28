import 'package:flutter/material.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/widgets/app_bottom_nav.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  int _activeCategory = 0;

  final _categories = const [
    'All', 'Blood Count', 'Lipid Profile', 'Diabetes', 'Thyroid',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Health Trends',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: context.textH,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list, size: 13, color: context.textM),
                        const SizedBox(width: 4),
                        Text(
                          'Filter',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: context.textM),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info note
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: context.primBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.primBord),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 13, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Trends are available for structured blood reports only, not imaging.',
                        style: TextStyle(fontSize: 11, color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category filter chips
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final active = i == _activeCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _activeCategory = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primaryColor : this.context.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: active ? AppColors.primaryColor : this.context.border),
                      ),
                      child: Text(
                        _categories[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: active ? Colors.white : this.context.textM,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Empty state
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.trending_up, size: 36, color: AppColors.successColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No trends yet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload blood test reports to start seeing how your health parameters change over time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.border),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: context.textL),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This is not medical advice. Trends are derived from your uploaded reports. Consult a healthcare professional for interpretation.',
                                style: TextStyle(fontSize: 11, color: context.textL, height: 1.5),
                              ),
                            ),
                          ],
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
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
