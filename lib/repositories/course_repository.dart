import '../models/course.dart';

class CourseRepository {
  // Dummy data (anggap dari database)
  final List<Course> _courses = [
    Course(
      id: "1",
      name: "Flutter Dasar",
      image: "assets/images/flutter.png",
      level: "Beginner",
      kdKelas: "FL01",
      progress: 40,
      nav: "/flutter-dasar",
    ),
    Course(
      id: "2",
      name: "Dart Intermediate",
      image: "assets/images/dart.png",
      level: "Intermediate",
      kdKelas: "DT02",
      progress: 100,
      nav: "/dart-intermediate",
    ),
  ];

  List<Course> getCourses() {
    return _courses;
  }

  void updateProgress(String id, int newProgress) {
    final course = _courses.firstWhere((c) => c.id == id);
    course.progress = newProgress;
    // nanti bagian ini bisa diganti simpan ke SQLite / Firestore
  }
}
