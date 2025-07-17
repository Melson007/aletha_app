# aletha_app



# Aletha Health Exercise App

A simple mobile exercise app built using Flutter and Dart to help users improve their physical well-being. Users can browse exercises, view exercise details, start a timer, and track their daily streak.

---
Author: Melson S

##  Features

- Fetches a list of exercises from REST API
- Exercise detail view with timer functionality
- Marks exercise as complete upon completion
- Tracks daily streak of exercise completion
- State management using BLoC
- Clean and modular code structure
- Responsive UI (basic)

---

##  Architecture

The app follows a layered architecture:

- `models/`: Defines the `Exercise` data model.
- `repository/`: Handles API calls using `http`.
- `bloc/`: Business logic with `ExerciseBloc`, `ExerciseState`, `ExerciseEvent`.
- `screens/`: UI views like `HomeScreen` and `ExerciseDetailScreen`.
- `main.dart`: App entry point with BlocProvider.

State is managed using **flutter_bloc** (BLoC pattern).

---

##  Known Shortcomings

- Basic UI without advanced responsiveness.
- No persistent local storage — streak resets if app is reinstalled or killed.
- No animations or loading indicators for transitions.
- No Figma design integration.

---

##  How to Run

1. Clone the repository
2. Run `flutter pub get`
3. Connect a device/emulator
4. Run the app using `flutter run`

---



##  API Endpoint Used

`GET https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts`
