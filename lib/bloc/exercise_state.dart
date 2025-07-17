part of 'exercise_bloc.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final Set<String> completedExerciseIds;
  final int streakCount;
  final DateTime? lastCompletedDate;

  const ExerciseLoaded({
    required this.exercises,
    required this.completedExerciseIds,
    required this.streakCount,
    required this.lastCompletedDate,
  });

  @override
  List<Object?> get props => [
        exercises,
        completedExerciseIds,
        streakCount,
        lastCompletedDate ?? DateTime(2000),
      ];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object> get props => [message];
}
