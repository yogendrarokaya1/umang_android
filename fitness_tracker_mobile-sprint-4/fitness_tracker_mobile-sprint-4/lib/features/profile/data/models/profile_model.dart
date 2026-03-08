import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.userId,
    super.gender,
    super.dateOfBirth,
    super.heightCm,
    super.bio,
    required super.fitnessLevel,
    required super.activityLevel,
    required super.preferredWeightUnit,
    required super.preferredHeightUnit,
    super.age,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      bio: json['bio'],
      fitnessLevel: json['fitnessLevel'] ?? 'beginner',
      activityLevel: json['activityLevel'] ?? 'sedentary',
      preferredWeightUnit: json['preferredWeightUnit'] ?? 'kg',
      preferredHeightUnit: json['preferredHeightUnit'] ?? 'cm',
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'dateOfBirth': dateOfBirth != null
          ? "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}"
          : null,
      'heightCm': heightCm,
      'bio': bio,
      'fitnessLevel': fitnessLevel,
      'activityLevel': activityLevel,
      'preferredWeightUnit': preferredWeightUnit,
      'preferredHeightUnit': preferredHeightUnit,
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      userId: entity.userId,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      heightCm: entity.heightCm,
      bio: entity.bio,
      fitnessLevel: entity.fitnessLevel,
      activityLevel: entity.activityLevel,
      preferredWeightUnit: entity.preferredWeightUnit,
      preferredHeightUnit: entity.preferredHeightUnit,
      age: entity.age,
    );
  }
}

class BodyMetricModel extends BodyMetricEntity {
  const BodyMetricModel({
    required super.id,
    required super.weightKg,
    super.bodyFatPercent,
    super.bmi,
    super.waistCm,
    super.hipsCm,
    super.chestCm,
    required super.recordedAt,
  });

  factory BodyMetricModel.fromJson(Map<String, dynamic> json) {
    return BodyMetricModel(
      id: json['_id'] ?? json['id'] ?? '',
      weightKg: (json['weightKg'] as num).toDouble(),
      bodyFatPercent: (json['bodyFatPercent'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      waistCm: (json['waistCm'] as num?)?.toDouble(),
      hipsCm: (json['hipsCm'] as num?)?.toDouble(),
      chestCm: (json['chestCm'] as num?)?.toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weightKg': weightKg,
      'bodyFatPercent': bodyFatPercent,
      'waistCm': waistCm,
      'hipsCm': hipsCm,
      'chestCm': chestCm,
    };
  }

  factory BodyMetricModel.fromEntity(BodyMetricEntity entity) {
    return BodyMetricModel(
      id: entity.id,
      weightKg: entity.weightKg,
      bodyFatPercent: entity.bodyFatPercent,
      bmi: entity.bmi,
      waistCm: entity.waistCm,
      hipsCm: entity.hipsCm,
      chestCm: entity.chestCm,
      recordedAt: entity.recordedAt,
    );
  }
}

class ProfileDashboardModel extends ProfileDashboardEntity {
  const ProfileDashboardModel({
    super.latestMetric,
    required super.progress,
  });

  factory ProfileDashboardModel.fromJson(Map<String, dynamic> json) {
    return ProfileDashboardModel(
      latestMetric: json['latestMetric'] != null 
          ? BodyMetricModel.fromJson(json['latestMetric']) 
          : null,
      progress: json['progress'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latestMetric': (latestMetric as BodyMetricModel?)?.toJson(),
      'progress': progress,
    };
  }
}
