import 'package:health_trace/src/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // To Entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}

class HealthProfileModel {
  final String userId;
  final int age;
  final String sex;
  final double height;
  final double weight;
  final String? bloodType;
  final List<String> medicalConditions;
  final List<MedicationModel> medications;
  final List<String> allergies;
  final LifestyleDataModel? lifestyle;
  final DateTime? lastUpdated;

  HealthProfileModel({
    required this.userId,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    this.bloodType,
    required this.medicalConditions,
    required this.medications,
    required this.allergies,
    this.lifestyle,
    this.lastUpdated,
  });

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) {
    return HealthProfileModel(
      userId: json['userId'] as String,
      age: json['age'] as int,
      sex: json['sex'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bloodType: json['bloodType'] as String?,
      medicalConditions: List<String>.from(json['medicalConditions'] as List? ?? []),
      medications: (json['medications'] as List?)
              ?.map((e) => MedicationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      lifestyle: json['lifestyle'] != null
          ? LifestyleDataModel.fromJson(json['lifestyle'] as Map<String, dynamic>)
          : null,
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'age': age,
      'sex': sex,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'medicalConditions': medicalConditions,
      'medications': medications.map((m) => m.toJson()).toList(),
      'allergies': allergies,
      'lifestyle': lifestyle?.toJson(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  HealthProfile toEntity() {
    return HealthProfile(
      userId: userId,
      age: age,
      sex: sex,
      height: height,
      weight: weight,
      bloodType: bloodType,
      medicalConditions: medicalConditions,
      medications: medications.map((m) => m.toEntity()).toList(),
      allergies: allergies,
      lifestyle: lifestyle?.toEntity(),
      lastUpdated: lastUpdated,
    );
  }
}

class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime? startDate;
  final DateTime? endDate;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.startDate,
    this.endDate,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Medication toEntity() {
    return Medication(
      id: id,
      name: name,
      dosage: dosage,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class LifestyleDataModel {
  final String? sleepHours;
  final String? exerciseFrequency;
  final String? dietType;
  final bool? isSmoker;
  final bool? isAlcoholConsumer;
  final String? stressLevel;

  LifestyleDataModel({
    this.sleepHours,
    this.exerciseFrequency,
    this.dietType,
    this.isSmoker,
    this.isAlcoholConsumer,
    this.stressLevel,
  });

  factory LifestyleDataModel.fromJson(Map<String, dynamic> json) {
    return LifestyleDataModel(
      sleepHours: json['sleepHours'] as String?,
      exerciseFrequency: json['exerciseFrequency'] as String?,
      dietType: json['dietType'] as String?,
      isSmoker: json['isSmoker'] as bool?,
      isAlcoholConsumer: json['isAlcoholConsumer'] as bool?,
      stressLevel: json['stressLevel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleepHours': sleepHours,
      'exerciseFrequency': exerciseFrequency,
      'dietType': dietType,
      'isSmoker': isSmoker,
      'isAlcoholConsumer': isAlcoholConsumer,
      'stressLevel': stressLevel,
    };
  }

  LifestyleData toEntity() {
    return LifestyleData(
      sleepHours: sleepHours,
      exerciseFrequency: exerciseFrequency,
      dietType: dietType,
      isSmoker: isSmoker,
      isAlcoholConsumer: isAlcoholConsumer,
      stressLevel: stressLevel,
    );
  }
}
