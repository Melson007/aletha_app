import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/exercise.dart';
import '../repository/exercise_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository repository;
  final Set<String> completedExerciseIds = {};

  ExerciseBloc(this.repository) : super(ExerciseInitial()) {
    on<FetchExercises>(_onFetchExercises);
    on<MarkExerciseComplete>(_onMarkExerciseComplete);
  }

  void _onFetchExercises(
      FetchExercises event, Emitter<ExerciseState> emit) async {
    emit(ExerciseLoading());
    try {
      final exercises = await repository.fetchExercises();

      emit(ExerciseLoaded(exercises, completedExerciseIds));
    } catch (e) {
      emit(ExerciseError("Failed to load exercisesaa"));
    }
  }

  void _onMarkExerciseComplete(
      MarkExerciseComplete event, Emitter<ExerciseState> emit) {
    completedExerciseIds.add(event.exerciseId);
    if (state is ExerciseLoaded) {
      final current = state as ExerciseLoaded;
      emit(ExerciseLoaded(current.exercises, completedExerciseIds));
    }
  }
}
