import 'package:fitness_tracker/features/workout/domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.name,
    super.description,
    required super.category,
    required super.muscleGroups,
    required super.equipment,
    required super.difficulty,
    super.instructions,
    super.videoUrl,
    super.imageUrl,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      category: json['category'] ?? 'strength',
      muscleGroups: List<String>.from(json['muscleGroups'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
      difficulty: json['difficulty'] ?? 'beginner',
      instructions: json['instructions'],
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'muscleGroups': muscleGroups,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    };
  }
}
