class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, fullName: $fullName)';
}

class HealthProfile {
  final String userId;
  final int age;
  final String sex; // Male, Female, Other
  final double height; // in cm
  final double weight; // in kg
  final String? bloodType;
  final List<String> medicalConditions;
  final List<Medication> medications;
  final List<String> allergies;
  final LifestyleData? lifestyle;
  final DateTime? lastUpdated;

  HealthProfile({
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

  double get bmi => weight / ((height / 100) * (height / 100));

  String getBmiCategory() {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  HealthProfile copyWith({
    String? userId,
    int? age,
    String? sex,
    double? height,
    double? weight,
    String? bloodType,
    List<String>? medicalConditions,
    List<Medication>? medications,
    List<String>? allergies,
    LifestyleData? lifestyle,
    DateTime? lastUpdated,
  }) {
    return HealthProfile(
      userId: userId ?? this.userId,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodType: bloodType ?? this.bloodType,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      medications: medications ?? this.medications,
      allergies: allergies ?? this.allergies,
      lifestyle: lifestyle ?? this.lifestyle,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() => 'HealthProfile(userId: $userId, age: $age, bmi: ${bmi.toStringAsFixed(2)})';
}

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime? startDate;
  final DateTime? endDate;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.startDate,
    this.endDate,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  String toString() => 'Medication(name: $name, dosage: $dosage, frequency: $frequency)';
}

class LifestyleData {
  final String? sleepHours;
  final String? exerciseFrequency;
  final String? dietType;
  final bool? isSmoker;
  final bool? isAlcoholConsumer;
  final String? stressLevel;

  LifestyleData({
    this.sleepHours,
    this.exerciseFrequency,
    this.dietType,
    this.isSmoker,
    this.isAlcoholConsumer,
    this.stressLevel,
  });

  LifestyleData copyWith({
    String? sleepHours,
    String? exerciseFrequency,
    String? dietType,
    bool? isSmoker,
    bool? isAlcoholConsumer,
    String? stressLevel,
  }) {
    return LifestyleData(
      sleepHours: sleepHours ?? this.sleepHours,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      dietType: dietType ?? this.dietType,
      isSmoker: isSmoker ?? this.isSmoker,
      isAlcoholConsumer: isAlcoholConsumer ?? this.isAlcoholConsumer,
      stressLevel: stressLevel ?? this.stressLevel,
    );
  }
}
