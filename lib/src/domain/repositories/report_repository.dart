import 'package:health_trace/src/domain/entities/report.dart';

abstract class ReportRepository {
  // Upload new report
  Future<Report> uploadReport({
    required String userId,
    required String filePath,
    required ReportType type,
    required DateTime reportDate,
    String? notes,
  });

  // Get all reports for user
  Future<List<Report>> getReports({
    required String userId,
    int? limit,
    int? offset,
  });

  // Get single report by ID
  Future<Report> getReportDetail({required String reportId});

  // Delete report
  Future<void> deleteReport({required String reportId});

  // Extract data from report
  Future<List<HealthParameter>> extractReportData({required String reportId});

  // Update extracted parameters
  Future<Report> updateReportParameters({
    required String reportId,
    required List<HealthParameter> parameters,
  });

  // Verify extracted data
  Future<Report> verifyReportData({required String reportId});

  // Search reports
  Future<List<Report>> searchReports({
    required String userId,
    required String query,
  });
}

abstract class TrendRepository {
  // Get all trends for user
  Future<List<Trend>> getTrends({required String userId});

  // Get detail for specific parameter
  Future<Trend> getTrendDetail({
    required String userId,
    required String parameterName,
    int? days, // last N days
  });

  // Calculate trend for parameters
  Future<List<Trend>> calculateTrends({
    required String userId,
    List<String>? parameterNames,
  });

  // Get abnormal parameters (parameters with abnormal values)
  Future<List<HealthParameter>> getAbnormalParameters({required String userId});

  // Get recent parameters (latest values)
  Future<List<HealthParameter>> getRecentParameters({
    required String userId,
    int? limit,
  });
}
