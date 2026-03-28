import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';

class ExtractionVerificationScreen extends StatefulWidget {
  final String? reportId;
  const ExtractionVerificationScreen({super.key, this.reportId});

  @override
  State<ExtractionVerificationScreen> createState() =>
      _ExtractionVerificationScreenState();
}

class _ExtractionVerificationScreenState
    extends State<ExtractionVerificationScreen> {
  final List<_EditableParam> _params = [];

  int get _confirmedCount => _params.where((p) => p.confirmed).length;
  int get _totalCount => _params.length;
  double get _completionPct => _totalCount == 0 ? 0 : _confirmedCount / _totalCount;

  void _confirmAll() {
    setState(() { for (final p in _params) {
      p.confirmed = true;
    } });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
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
                      Text('Verify Extraction',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textH)),
                      Text('Review AI-extracted data',
                        style: TextStyle(fontSize: 11, color: context.textM)),
                    ],
                  ),
                ],
              ),
            ),

            // AI trust banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: context.primBg, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.primBord),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: AppColors.primaryColor),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'AI extraction is ~97% accurate. Please verify each value before confirming.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryColor, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Progress card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surface, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_confirmedCount/$_totalCount parameters confirmed',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH),
                        ),
                        Text(
                          '${(_completionPct * 100).round()}%',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _completionPct,
                        minHeight: 6,
                        backgroundColor: context.border,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: _params.isEmpty
                  ? _buildEmptyState()
                  : _buildParamList(),
            ),

            if (_params.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _confirmedCount == _totalCount ? null : _confirmAll,
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Confirm All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: context.border,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: context.primBg, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.assignment_outlined, size: 34, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            Text('No parameters to verify',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text(
              'Upload a report first. AI extraction will identify parameters for you to verify here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => context.go('/reports'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, borderRadius: BorderRadius.circular(12)),
                child: const Text('Go to Reports',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParamList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _params.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final param = _params[index];
        return _ParamRow(
          param: param,
          onToggleConfirm: () => setState(() => param.confirmed = !param.confirmed),
          onToggleEdit: () => setState(() => param.isEditing = !param.isEditing),
          onSave: (val) => setState(() { param.editedValue = val; param.isEditing = false; }),
        );
      },
    );
  }
}

//  Model 
class _EditableParam {
  final String id, name, value, unit, status;
  final double confidence;
  bool confirmed = false, isEditing = false;
  String editedValue;

  _EditableParam({
    required this.id, required this.name, required this.value,
    required this.unit, required this.status, required this.confidence, String? editedValue,
  }) : editedValue = editedValue ?? value;
}

//  Param Row 
class _ParamRow extends StatefulWidget {
  final _EditableParam param;
  final VoidCallback onToggleConfirm, onToggleEdit;
  final ValueChanged<String> onSave;

  const _ParamRow({
    required this.param,
    required this.onToggleConfirm,
    required this.onToggleEdit,
    required this.onSave,
  });

  @override
  State<_ParamRow> createState() => _ParamRowState();
}

class _ParamRowState extends State<_ParamRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.param.editedValue);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Color get _confColor {
    final pct = widget.param.confidence * 100;
    if (pct >= 95) return AppColors.successColor;
    if (pct >= 85) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color get _confBg {
    final pct = widget.param.confidence * 100;
    if (pct >= 95) return AppColors.successBg;
    if (pct >= 85) return AppColors.warningBg;
    return AppColors.errorBg;
  }

  String get _confLabel {
    final pct = widget.param.confidence * 100;
    if (pct >= 95) return 'High confidence';
    if (pct >= 85) return 'Medium confidence';
    return 'Low confidence';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.param;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.confirmed ? AppColors.successColor : context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(p.name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textH)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: _confBg, borderRadius: BorderRadius.circular(6)),
                child: Text(_confLabel,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _confColor)),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: widget.onToggleEdit,
                child: Icon(p.isEditing ? Icons.close : Icons.edit_outlined, size: 14, color: context.textM),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: widget.onToggleConfirm,
                child: Icon(
                  p.confirmed ? Icons.check_circle : Icons.check_circle_outline,
                  size: 18,
                  color: p.confirmed ? AppColors.successColor : context.textL,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (p.isEditing)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 13, color: context.textH),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => widget.onSave(_controller.text.trim()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Save', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text('${p.editedValue} ${p.unit}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textH)),
              ],
            ),
        ],
      ),
    );
  }
}
