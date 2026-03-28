import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/widgets/app_widgets.dart';

class ReportDetailScreen extends StatefulWidget {
  final String? reportId;
  const ReportDetailScreen({super.key, this.reportId});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  int _activeTab = 0;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIconButton(icon: Icons.arrow_back, onTap: () => context.pop()),
                  Row(
                    children: [
                      AppIconButton(icon: Icons.share_outlined),
                      const SizedBox(width: 8),
                      AppIconButton(icon: Icons.download_outlined),
                    ],
                  ),
                ],
              ),
            ),

            // Report info card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: context.bg, borderRadius: BorderRadius.circular(14)),
                      child: const Center(child: Text('', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reportId != null ? 'Report ${widget.reportId}' : 'Report Detail',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textH),
                          ),
                          const SizedBox(height: 6),
                          _infoChip(Icons.calendar_today_outlined, 'Date: --'),
                          _infoChip(Icons.business_outlined, 'Lab: --'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  _tab('Extracted Data', 0),
                  const SizedBox(width: 8),
                  _tab('Original Report', 1),
                ],
              ),
            ),

            Expanded(
              child: _activeTab == 0
                  ? _buildExtractedEmpty()
                  : _buildOriginalEmpty(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, int idx) {
    final active = _activeTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? AppColors.primaryColor : context.border),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: active ? Colors.white : context.textM,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtractedEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: context.primBg, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.table_chart_outlined, size: 34, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            Text('No extracted data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text(
              "This report hasn't been processed yet, or contains no extractable parameters.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: context.bg, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.border),
              ),
              child: Icon(Icons.description_outlined, size: 34, color: context.textM),
            ),
            const SizedBox(height: 16),
            Text('No original file',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text('The original document is not available.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.textM, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 13, color: AppColors.warningColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Extracted data is based on AI analysis of the uploaded report.',
                      style: TextStyle(fontSize: 11, color: AppColors.warningColor, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 10, color: context.textM),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: context.textM)),
        ],
      ),
    );
  }
}
