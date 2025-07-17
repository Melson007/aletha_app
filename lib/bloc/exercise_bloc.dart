import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/exercise.dart';
import '../repository/exercise_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository repository;
  final Set<String> completedExerciseIds = {};
  DateTime? lastCompletedDate;
  int streakCount = 0;

  ExerciseBloc(this.repository) : super(ExerciseInitial()) {
    on<FetchExercises>(_onFetchExercises);
    on<MarkExerciseComplete>(_onMarkExerciseComplete);
  }

  void _onFetchExercises(
      FetchExercises event, Emitter<ExerciseState> emit) async {
    emit(ExerciseLoading());
    try {
      final exercises = await repository.fetchExercises();

      emit(ExerciseLoaded(
        exercises: exercises,
        completedExerciseIds: completedExerciseIds,
        streakCount: streakCount,
        lastCompletedDate: lastCompletedDate,
      ));
    } catch (e) {
      emit(ExerciseError("Failed to load exercises"));
    }
  }

  void _onMarkExerciseComplete(
      MarkExerciseComplete event, Emitter<ExerciseState> emit) {
    completedExerciseIds.add(event.exerciseId);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastCompletedDate == null) {
      streakCount = 1;
    } else {
      final last = DateTime(lastCompletedDate!.year, lastCompletedDate!.month,
          lastCompletedDate!.day);
      if (today.difference(last).inDays == 1) {
        streakCount += 1;
      } else if (today.difference(last).inDays > 1) {
        streakCount = 1; // reset streak
      }
    }

    lastCompletedDate = today;

    if (state is ExerciseLoaded) {
      final current = state as ExerciseLoaded;
      emit(ExerciseLoaded(
        exercises: current.exercises,
        completedExerciseIds: completedExerciseIds,
        streakCount: streakCount,
        lastCompletedDate: lastCompletedDate,
      ));
    }
  }
}
