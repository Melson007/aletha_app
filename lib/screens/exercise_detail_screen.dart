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

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  int _timeLeft = 0;
  Timer? _timer;
  bool _started = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.exercise.duration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.exercise.duration),
    );
  }

  void _startTimer() {
    setState(() {
      _started = true;
    });
    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_timeLeft == 0) {
        timer.cancel();
        BlocProvider.of<ExerciseBloc>(context)
            .add(MarkExerciseComplete(widget.exercise.id));

        await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "Exercise Completed!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _controller.stop();
    setState(() {
      _started = false;
      _timeLeft = widget.exercise.duration;
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return Scaffold(
      appBar: AppBar(
        title: Text(e.name),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: _started ? _controller.value : 0.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 12,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Text(
                    "$_timeLeft s",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              e.description,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Duration: ${e.duration} seconds",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              "Difficulty: ${e.difficulty}",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            if (!_started)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _startTimer,
                child: const Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_started)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _stopTimer,
                child: const Text(
                  "Stop",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
