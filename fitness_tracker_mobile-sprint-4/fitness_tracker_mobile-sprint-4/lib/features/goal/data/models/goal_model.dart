import 'package:fitness_tracker/features/goal/domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    super.description,
    super.targetValue,
    super.currentValue,
    super.unit,
    super.direction,
    super.deadline,
    required super.status,
    super.completedValue,
    super.completedAt,
    super.progressPercent,
    super.daysRemaining,
    super.isOverdue,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? 'custom',
      title: json['title'] ?? '',
      description: json['description'],
      targetValue: (json['targetValue'] as num?)?.toDouble(),
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      unit: json['unit'],
      direction: json['direction'],
      deadline: json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,
      status: json['status'] ?? 'active',
      completedValue: (json['completedValue'] as num?)?.toDouble(),
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      progressPercent: (json['progressPercent'] as num?)?.toDouble(),
      daysRemaining: json['daysRemaining'] as int?,
      isOverdue: json['isOverdue'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unit': unit,
      'direction': direction,
      'deadline': deadline?.toIso8601String(),
      'status': status,
    };
  }

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      description: entity.description,
      targetValue: entity.targetValue,
      currentValue: entity.currentValue,
      unit: entity.unit,
      direction: entity.direction,
      deadline: entity.deadline,
      status: entity.status,
      completedValue: entity.completedValue,
      completedAt: entity.completedAt,
      progressPercent: entity.progressPercent,
      daysRemaining: entity.daysRemaining,
      isOverdue: entity.isOverdue,
    );
  }
}

class GoalSummaryModel extends GoalSummaryEntity {
  const GoalSummaryModel({
    required super.active,
    required super.completed,
    required super.abandoned,
    required super.overdue,
  });

  factory GoalSummaryModel.fromJson(Map<String, dynamic> json) {
    return GoalSummaryModel(
      active: json['active'] ?? 0,
      completed: json['completed'] ?? 0,
      abandoned: json['abandoned'] ?? 0,
      overdue: json['overdue'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'completed': completed,
      'abandoned': abandoned,
      'overdue': overdue,
    };
  }
}
