import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? heightCm;
  final String? bio;
  final String fitnessLevel;
  final String activityLevel;
  final String preferredWeightUnit;
  final String preferredHeightUnit;
  final int? age;

  const ProfileEntity({
    required this.id,
    required this.userId,
    this.gender,
    this.dateOfBirth,
    this.heightCm,
    this.bio,
    required this.fitnessLevel,
    required this.activityLevel,
    required this.preferredWeightUnit,
    required this.preferredHeightUnit,
    this.age,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        gender,
        dateOfBirth,
        heightCm,
        bio,
        fitnessLevel,
        activityLevel,
        preferredWeightUnit,
        preferredHeightUnit,
        age,
      ];
}

class BodyMetricEntity extends Equatable {
  final String id;
  final double weightKg;
  final double? bodyFatPercent;
  final double? bmi;
  final double? waistCm;
  final double? hipsCm;
  final double? chestCm;
  final DateTime recordedAt;

  const BodyMetricEntity({
    required this.id,
    required this.weightKg,
    this.bodyFatPercent,
    this.bmi,
    this.waistCm,
    this.hipsCm,
    this.chestCm,
    required this.recordedAt,
  });

  @override
  List<Object?> get props => [
        id,
        weightKg,
        bodyFatPercent,
        bmi,
        waistCm,
        hipsCm,
        chestCm,
        recordedAt,
      ];
}

class ProfileDashboardEntity extends Equatable {
  final BodyMetricEntity? latestMetric;
  final Map<String, dynamic> progress;

  const ProfileDashboardEntity({
    this.latestMetric,
    required this.progress,
  });

  @override
  List<Object?> get props => [latestMetric, progress];
}
