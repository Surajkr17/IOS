class DoctorVisit {
  final String id;
  final String userId;
  final String doctorType;
  final String visitPurpose;
  final List<String> selectedParameters;
  final List<String> selectedReports;
  final String? generatedSummary;
  final String? refinedSummary;
  final bool isSummarized;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorVisit({
    required this.id,
    required this.userId,
    required this.doctorType,
    required this.visitPurpose,
    required this.selectedParameters,
    required this.selectedReports,
    this.generatedSummary,
    this.refinedSummary,
    this.isSummarized = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get summary => refinedSummary ?? generatedSummary ?? '';

  DoctorVisit copyWith({
    String? id,
    String? userId,
    String? doctorType,
    String? visitPurpose,
    List<String>? selectedParameters,
    List<String>? selectedReports,
    String? generatedSummary,
    String? refinedSummary,
    bool? isSummarized,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorVisit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorType: doctorType ?? this.doctorType,
      visitPurpose: visitPurpose ?? this.visitPurpose,
      selectedParameters: selectedParameters ?? this.selectedParameters,
      selectedReports: selectedReports ?? this.selectedReports,
      generatedSummary: generatedSummary ?? this.generatedSummary,
      refinedSummary: refinedSummary ?? this.refinedSummary,
      isSummarized: isSummarized ?? this.isSummarized,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'DoctorVisit(id: $id, docType: $doctorType, purpose: $visitPurpose)';
}

class DoctorVisitSummaryRequest {
  final String userId;
  final String doctorType;
  final String visitPurpose;
  final List<String> parameters;
  final List<String> reportIds;
  final String? additionalNotes;

  DoctorVisitSummaryRequest({
    required this.userId,
    required this.doctorType,
    required this.visitPurpose,
    required this.parameters,
    required this.reportIds,
    this.additionalNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'doctorType': doctorType,
      'visitPurpose': visitPurpose,
      'parameters': parameters,
      'reportIds': reportIds,
      'additionalNotes': additionalNotes,
    };
  }
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

  Insight copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    InsightType? type,
    List<String>? affectedParameters,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Insight(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      affectedParameters: affectedParameters ?? this.affectedParameters,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() => 'Insight(id: $id, title: $title, type: $type)';
}

enum InsightType {
  warning,
  info,
  success,
  trend,
  recommendation,
}
