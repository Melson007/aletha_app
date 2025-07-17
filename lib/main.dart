import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/exercise_bloc.dart';
import 'repository/exercise_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ExerciseRepository repository = ExerciseRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aletha Health Exercise App',
      home: BlocProvider(
        create: (_) => ExerciseBloc(repository)..add(FetchExercises()),
        child: HomeScreen(),
      ),
    );
  }
}
