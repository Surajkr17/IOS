import 'package:flutter/material.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';
import 'package:health_trace/src/presentation/widgets/app_bottom_nav.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _activeTab = 0;
  bool _showSearch = false;
  final _searchCtrl = TextEditingController();
  bool _showUploadSheet = false;
  bool _uploading = false;
  double _uploadProgress = 0;
  String _uploadStatus = 'idle';

  final _tabs = const ['All', 'Blood', 'Imaging', 'Other'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    setState(() { _uploading = true; _uploadStatus = 'uploading'; _uploadProgress = 0; });
    _runUploadProgress();
  }

  void _runUploadProgress() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() { _uploadProgress += 0.12; });
      if (_uploadProgress >= 1.0) {
        setState(() { _uploadProgress = 1.0; _uploadStatus = 'processing'; });
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() => _uploadStatus = 'success');
        });
      } else {
        _runUploadProgress();
      }
    });
  }

  void _resetUpload() {
    setState(() {
      _showUploadSheet = false; _uploading = false;
      _uploadProgress = 0; _uploadStatus = 'idle';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabs(),
                Expanded(child: _buildEmptyState()),
              ],
            ),
          ),
          if (_showUploadSheet) _buildUploadOverlay(),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('My Reports',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: context.textH)),
              ),
              GestureDetector(
                onTap: () => setState(() => _showSearch = !_showSearch),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: context.surface, borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.border),
                  ),
                  child: Icon(Icons.search, size: 16, color: context.textM),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _showUploadSheet = true),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _showSearch
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: _searchCtrl,
                      autofocus: true,
                      style: TextStyle(fontSize: 13, color: context.textH),
                      decoration: InputDecoration(
                        hintText: 'Search reports...',
                        hintStyle: TextStyle(fontSize: 13, color: context.textM),
                        prefixIcon: Icon(Icons.search, size: 16, color: context.textM),
                        filled: true,
                        fillColor: context.surface,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: context.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: context.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tabs.length,
        itemBuilder: (context, i) {
          final active = i == _activeTab;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryColor : context.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: active ? AppColors.primaryColor : context.border),
              ),
              child: Text(
                _tabs[i],
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500,
                  color: active ? Colors.white : context.textM,
                ),
              ),
            ),
          );
        },
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
              width: 80, height: 80,
              decoration: BoxDecoration(color: context.primBg, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.folder_open_outlined, size: 36, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            Text('No reports yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text(
              'Upload your first health report to start tracking and analysing your health data.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.textM, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => setState(() => _showUploadSheet = true),
              icon: const Icon(Icons.upload_outlined, size: 16),
              label: const Text('Upload Report',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOverlay() {
    return GestureDetector(
      onTap: _resetUpload,
      child: Container(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: _uploadStatus == 'idle'
                    ? _buildUploadOptions()
                    : _buildUploadProgress(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOptions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: context.border, borderRadius: BorderRadius.circular(2)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upload Report',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: context.textH)),
              GestureDetector(
                onTap: _resetUpload,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: context.bg, borderRadius: BorderRadius.circular(16)),
                  child: Icon(Icons.close, size: 16, color: context.textM),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _uploadOption(
            icon: Icons.camera_alt_outlined, label: 'Take Photo',
            sub: 'Capture report with camera', onTap: _simulateUpload),
          const SizedBox(height: 12),
          _uploadOption(
            icon: Icons.photo_library_outlined, label: 'Choose from Gallery',
            sub: 'Select from your photos', onTap: _simulateUpload),
          const SizedBox(height: 12),
          _uploadOption(
            icon: Icons.folder_outlined, label: 'Browse Files',
            sub: 'PDF, JPEG, PNG supported', onTap: _simulateUpload),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: context.primBg, borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.lock_outline, size: 14, color: AppColors.primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your reports are encrypted and stored securely',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _uploadOption({
    required IconData icon, required String label,
    required String sub, required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.bg, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: context.surface, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.textH)),
                  Text(sub, style: TextStyle(fontSize: 11, color: context.textM)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: context.textM),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: context.border, borderRadius: BorderRadius.circular(2)),
          ),
          if (_uploadStatus == 'uploading') ...[
            const Icon(Icons.upload_file_outlined, size: 40, color: AppColors.primaryColor),
            const SizedBox(height: 12),
            Text('Uploading report...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: context.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text('${(_uploadProgress * 100).toInt()}%',
              style: TextStyle(fontSize: 13, color: context.textM)),
          ] else if (_uploadStatus == 'processing') ...[
            const CircularProgressIndicator(color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text('AI is reading your report...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text('Extracting health parameters', style: TextStyle(fontSize: 13, color: context.textM)),
          ] else if (_uploadStatus == 'success') ...[
            Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, size: 36, color: AppColors.successColor),
            ),
            const SizedBox(height: 16),
            Text('Report processed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.textH)),
            const SizedBox(height: 8),
            Text('Data has been extracted successfully.',
              style: TextStyle(fontSize: 13, color: context.textM)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
