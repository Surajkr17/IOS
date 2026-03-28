import 'package:health_trace/src/domain/entities/report.dart';

class ReportModel {
  final String id;
  final String userId;
  final String fileName;
  final String? filePath;
  final String? fileUrl;
  final String type;
  final DateTime reportDate;
  final DateTime uploadedAt;
  final List<HealthParameterModel> parameters;
  final String? notes;
  final bool isVerified;

  ReportModel({
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String?,
      fileUrl: json['fileUrl'] as String?,
      type: json['type'] as String,
      reportDate: DateTime.parse(json['reportDate'] as String),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      parameters: (json['parameters'] as List?)
              ?.map((e) => HealthParameterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'filePath': filePath,
      'fileUrl': fileUrl,
      'type': type,
      'reportDate': reportDate.toIso8601String(),
      'uploadedAt': uploadedAt.toIso8601String(),
      'parameters': parameters.map((p) => p.toJson()).toList(),
      'notes': notes,
      'isVerified': isVerified,
    };
  }

  Report toEntity() {
    return Report(
      id: id,
      userId: userId,
      fileName: fileName,
      filePath: filePath,
      fileUrl: fileUrl,
      type: _parseReportType(type),
      reportDate: reportDate,
      uploadedAt: uploadedAt,
      parameters: parameters.map((p) => p.toEntity()).toList(),
      notes: notes,
      isVerified: isVerified,
    );
  }

  static ReportType _parseReportType(String type) {
    switch (type.toLowerCase()) {
      case 'bloodtest':
        return ReportType.bloodTest;
      case 'urinalysis':
        return ReportType.urinalysis;
      case 'xray':
        return ReportType.xray;
      case 'ultrasound':
        return ReportType.ultrasound;
      case 'ecg':
        return ReportType.ecg;
      default:
        return ReportType.other;
    }
  }
}

class HealthParameterModel {
  final String id;
  final String name;
  final String value;
  final String unit;
  final String? referenceMin;
  final String? referenceMax;
  final String status;
  final double? confidenceScore;
  final String? notes;

  HealthParameterModel({
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

  factory HealthParameterModel.fromJson(Map<String, dynamic> json) {
    return HealthParameterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String,
      referenceMin: json['referenceMin'] as String?,
      referenceMax: json['referenceMax'] as String?,
      status: json['status'] as String? ?? 'normal',
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'referenceMin': referenceMin,
      'referenceMax': referenceMax,
      'status': status,
      'confidenceScore': confidenceScore,
      'notes': notes,
    };
  }

  HealthParameter toEntity() {
    return HealthParameter(
      id: id,
      name: name,
      value: value,
      unit: unit,
      referenceMin: referenceMin,
      referenceMax: referenceMax,
      status: _parseStatus(status),
      confidenceScore: confidenceScore,
      notes: notes,
    );
  }

  static ParameterStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'abnormal':
        return ParameterStatus.abnormal;
      case 'critical':
        return ParameterStatus.critical;
      default:
        return ParameterStatus.normal;
    }
  }
}

class TrendModel {
  final String id;
  final String userId;
  final String parameterName;
  final List<TrendDataPointModel> dataPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrendModel({
    required this.id,
    required this.userId,
    required this.parameterName,
    required this.dataPoints,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) {
    return TrendModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      parameterName: json['parameterName'] as String,
      dataPoints: (json['dataPoints'] as List?)
              ?.map((e) => TrendDataPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'parameterName': parameterName,
      'dataPoints': dataPoints.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Trend toEntity() {
    return Trend(
      id: id,
      userId: userId,
      parameterName: parameterName,
      dataPoints: dataPoints.map((p) => p.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class TrendDataPointModel {
  final DateTime date;
  final double value;
  final String? unit;
  final String? source;

  TrendDataPointModel({
    required this.date,
    required this.value,
    this.unit,
    this.source,
  });

  factory TrendDataPointModel.fromJson(Map<String, dynamic> json) {
    return TrendDataPointModel(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String?,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
      'unit': unit,
      'source': source,
    };
  }

  TrendDataPoint toEntity() {
    return TrendDataPoint(
      date: date,
      value: value,
      unit: unit,
      source: source,
    );
  }
}
