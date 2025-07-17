import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/exercise.dart';
import '../bloc/exercise_bloc.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _timeLeft = 0;
  Timer? _timer;
  bool _started = false;

  void _startTimer() {
    setState(() {
      _timeLeft = widget.exercise.duration;
      _started = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_timeLeft == 0) {
        timer.cancel();
        BlocProvider.of<ExerciseBloc>(context)
            .add(MarkExerciseComplete(widget.exercise.id));

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Exercise Completed"),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        setState(() => _timeLeft--);
        debugPrint('_timeLeft ${_timeLeft}');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return Scaffold(
      appBar: AppBar(title: Text(e.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${e.description}"),
            const SizedBox(height: 8),
            Text("Duration: ${e.duration} seconds"),
            const SizedBox(height: 8),
            Text("Difficulty: ${e.difficulty}"),
            const SizedBox(height: 24),
            if (!_started)
              ElevatedButton(
                onPressed: _startTimer,
                child: const Text("Start"),
              ),
            if (_started)
              Text("Time Left: $_timeLeft s",
                  style: const TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
