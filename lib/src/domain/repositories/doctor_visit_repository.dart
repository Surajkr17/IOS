import 'package:health_trace/src/domain/entities/doctor_visit.dart';

abstract class DoctorVisitRepository {
  // Create new doctor visit
  Future<DoctorVisit> createDoctorVisit({
    required String userId,
    required String doctorType,
    required String visitPurpose,
    required List<String> selectedParameters,
    required List<String> selectedReports,
  });

  // Get all doctor visits
  Future<List<DoctorVisit>> getDoctorVisits({required String userId});

  // Get doctor visit detail
  Future<DoctorVisit> getDoctorVisitDetail({required String visitId});

  // Generate summary
  Future<String> generateSummary({required DoctorVisitSummaryRequest request});

  // Refine summary with AI
  Future<String> refineSummary({
    required String visitId,
    required String userFeedback,
  });

  // Update doctor visit
  Future<DoctorVisit> updateDoctorVisit({
    required String visitId,
    String? generatedSummary,
    String? refinedSummary,
    bool? isSummarized,
  });

  // Delete doctor visit
  Future<void> deleteDoctorVisit({required String visitId});
}

abstract class InsightRepository {
  // Get all insights
  Future<List<Insight>> getInsights({required String userId});

  // Get unread insights
  Future<List<Insight>> getUnreadInsights({required String userId});

  // Mark insight as read
  Future<void> markInsightAsRead({required String insightId});

  // Generate insights
  Future<List<Insight>> generateInsights({required String userId});

  // Delete insight
  Future<void> deleteInsight({required String insightId});
}

class Insight {
  final String id;
  final String userId;
  final String title;
  final String description;
  final InsightType type;
  final List<String>? affectedParameters;
  final DateTime createdAt;
  final bool isRead;

  Insight({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.affectedParameters,
    required this.createdAt,
    this.isRead = false,
  });
}

enum InsightType {
  warning,
  info,
  success,
  trend,
  recommendation,
}
