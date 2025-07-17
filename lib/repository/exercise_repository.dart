import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

class ExerciseRepository {
  final String _baseUrl =
      'https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts';

  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(_baseUrl));
    debugPrint('failed ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercisesq');
    }
  }
}
