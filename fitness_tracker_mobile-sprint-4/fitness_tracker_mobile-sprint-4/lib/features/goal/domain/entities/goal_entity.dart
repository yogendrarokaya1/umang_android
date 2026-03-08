import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? description;
  final double? targetValue;
  final double? currentValue;
  final String? unit;
  final String? direction;
  final DateTime? deadline;
  final String status;
  final double? completedValue;
  final DateTime? completedAt;
  final double? progressPercent;
  final int? daysRemaining;
  final bool? isOverdue;

  const GoalEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.targetValue,
    this.currentValue,
    this.unit,
    this.direction,
    this.deadline,
    required this.status,
    this.completedValue,
    this.completedAt,
    this.progressPercent,
    this.daysRemaining,
    this.isOverdue,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        description,
        targetValue,
        currentValue,
        unit,
        direction,
        deadline,
        status,
        completedValue,
        completedAt,
        progressPercent,
        daysRemaining,
        isOverdue,
      ];
}

class GoalSummaryEntity extends Equatable {
  final int active;
  final int completed;
  final int abandoned;
  final int overdue;

  const GoalSummaryEntity({
    required this.active,
    required this.completed,
    required this.abandoned,
    required this.overdue,
  });

  @override
  List<Object?> get props => [active, completed, abandoned, overdue];
}
