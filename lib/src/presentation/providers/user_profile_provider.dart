import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String dob;
  final String sex;
  final String height;
  final String weight;
  final double? bmi;
  final List<String> conditions;
  final List<String> medications;
  final List<String> allergies;
  final String smoking;
  final String alcohol;
  final String activity;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.dob = '',
    this.sex = '',
    this.height = '',
    this.weight = '',
    this.bmi,
    this.conditions = const [],
    this.medications = const [],
    this.allergies = const [],
    this.smoking = '',
    this.alcohol = '',
    this.activity = '',
  });

  int? get age {
    if (dob.isEmpty) return null;
    final d = DateTime.tryParse(dob);
    if (d == null) return null;
    final now = DateTime.now();
    int a = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) a--;
    return a;
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return '';
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? dob,
    String? sex,
    String? height,
    String? weight,
    double? bmi,
    List<String>? conditions,
    List<String>? medications,
    List<String>? allergies,
    String? smoking,
    String? alcohol,
    String? activity,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      conditions: conditions ?? this.conditions,
      medications: medications ?? this.medications,
      allergies: allergies ?? this.allergies,
      smoking: smoking ?? this.smoking,
      alcohol: alcohol ?? this.alcohol,
      activity: activity ?? this.activity,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(const UserProfile());

  void update(UserProfile profile) => state = profile;
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
  (ref) => UserProfileNotifier(),
);
