part of 'exercise_bloc.dart';

abstract class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final Set<String> completedIds;
  ExerciseLoaded(this.exercises, this.completedIds);

  @override
  List<Object?> get props => [exercises, completedIds];
}

class ExerciseError extends ExerciseState {
  final String message;
  ExerciseError(this.message);
  @override
  List<Object?> get props => [message];
}
