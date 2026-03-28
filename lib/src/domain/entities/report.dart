class Report {
  final String id;
  final String userId;
  final String fileName;
  final String? filePath;
  final String? fileUrl;
  final ReportType type;
  final DateTime reportDate;
  final DateTime uploadedAt;
  final List<HealthParameter> parameters;
  final String? notes;
  final bool isVerified;

  Report({
    required this.id,
    required this.userId,
    required this.fileName,
    this.filePath,
    this.fileUrl,
    required this.type,
    required this.reportDate,
    required this.uploadedAt,
    required this.parameters,
    this.notes,
    this.isVerified = false,
  });

  Report copyWith({
    String? id,
    String? userId,
    String? fileName,
    String? filePath,
    String? fileUrl,
    ReportType? type,
    DateTime? reportDate,
    DateTime? uploadedAt,
    List<HealthParameter>? parameters,
    String? notes,
    bool? isVerified,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
      reportDate: reportDate ?? this.reportDate,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      parameters: parameters ?? this.parameters,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() => 'Report(id: $id, type: $type, uploadedAt: $uploadedAt)';
}

enum ReportType {
  bloodTest,
  urinalysis,
  xray,
  ultrasound,
  ecg,
  other,
}

class HealthParameter {
  final String id;
  final String name;
  final String value;
  final String unit;
  final String? referenceMin;
  final String? referenceMax;
  final ParameterStatus status; // Normal, Abnormal, Critical
  final double? confidenceScore; // 0-1
  final String? notes;

  HealthParameter({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    this.referenceMin,
    this.referenceMax,
    required this.status,
    this.confidenceScore,
    this.notes,
  });

  bool get isAbnormal => status != ParameterStatus.normal;
  bool get isCritical => status == ParameterStatus.critical;

  HealthParameter copyWith({
    String? id,
    String? name,
    String? value,
    String? unit,
    String? referenceMin,
    String? referenceMax,
    ParameterStatus? status,
    double? confidenceScore,
    String? notes,
  }) {
    return HealthParameter(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      referenceMin: referenceMin ?? this.referenceMin,
      referenceMax: referenceMax ?? this.referenceMax,
      status: status ?? this.status,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() => 'HealthParameter(name: $name, value: $value $unit, status: $status)';
}

enum ParameterStatus {
  normal,
  abnormal,
  critical,
}

class Trend {
  final String id;
  final String userId;
  final String parameterName;
  final List<TrendDataPoint> dataPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trend({
    required this.id,
    required this.userId,
    required this.parameterName,
    required this.dataPoints,
    required this.createdAt,
    required this.updatedAt,
  });

  double? get averageValue {
    if (dataPoints.isEmpty) return null;
    final sum = dataPoints.fold<double>(0, (sum, point) => sum + point.value);
    return sum / dataPoints.length;
  }

  double? get minValue {
    if (dataPoints.isEmpty) return null;
    return dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);
  }

  double? get maxValue {
    if (dataPoints.isEmpty) return null;
    return dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);
  }

  String get trend {
    if (dataPoints.isEmpty || dataPoints.length < 2) return 'Stable';
    final latest = dataPoints.last.value;
    final previous = dataPoints[dataPoints.length - 2].value;
    if (latest > previous) return 'Increasing';
    if (latest < previous) return 'Decreasing';
    return 'Stable';
  }

  Trend copyWith({
    String? id,
    String? userId,
    String? parameterName,
    List<TrendDataPoint>? dataPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trend(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parameterName: parameterName ?? this.parameterName,
      dataPoints: dataPoints ?? this.dataPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Trend(parameterName: $parameterName, avg: ${averageValue?.toStringAsFixed(2)})';
}

class TrendDataPoint {
  final DateTime date;
  final double value;
  final String? unit;
  final String? source; // Report ID or manual entry

  TrendDataPoint({
    required this.date,
    required this.value,
    this.unit,
    this.source,
  });

  TrendDataPoint copyWith({
    DateTime? date,
    double? value,
    String? unit,
    String? source,
  }) {
    return TrendDataPoint(
      date: date ?? this.date,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source ?? this.source,
    );
  }

  @override
  String toString() => 'TrendDataPoint(date: $date, value: $value $unit)';
}
