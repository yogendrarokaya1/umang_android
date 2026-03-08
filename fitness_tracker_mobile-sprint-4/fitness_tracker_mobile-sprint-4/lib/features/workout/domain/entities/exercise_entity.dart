import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String category;
  final List<String> muscleGroups;
  final List<String> equipment;
  final String difficulty;
  final String? instructions;
  final String? videoUrl;
  final String? imageUrl;

  const ExerciseEntity({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.muscleGroups,
    required this.equipment,
    required this.difficulty,
    this.instructions,
    this.videoUrl,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        muscleGroups,
        equipment,
        difficulty,
        instructions,
        videoUrl,
        imageUrl,
      ];
}
