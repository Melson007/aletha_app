part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchExercises extends ExerciseEvent {}
class MarkExerciseComplete extends ExerciseEvent {
  final String exerciseId;
  MarkExerciseComplete(this.exerciseId);
  @override
  List<Object?> get props => [exerciseId];
}

