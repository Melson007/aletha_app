import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/exercise_bloc.dart';
import 'exercise_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daily Fitness"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                "Good Morning 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Here are your exercises for today",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              Expanded(
                child: BlocBuilder<ExerciseBloc, ExerciseState>(
                  builder: (context, state) {
                    if (state is ExerciseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ExerciseLoaded) {
                      return ListView.builder(
                        itemCount: state.exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = state.exercises[index];
                          final completed =
                              state.completedExerciseIds.contains(exercise.id);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/image${index % 7}.png",
                                ),
                                radius: 30,
                              ),
                              title: Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text("Duration: ${exercise.duration}s"),
                              trailing: completed
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.play_arrow,
                                      color: Colors.blueAccent),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<ExerciseBloc>(
                                          context),
                                      child: ExerciseDetailScreen(
                                          exercise: exercise),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is ExerciseError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
