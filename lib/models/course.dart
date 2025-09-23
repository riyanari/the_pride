class Course {
  final String id;
  final String name;
  final String image;
  final String level;
  final String kdKelas;
  int progress; // progress % (0–100)
  final String nav;

  Course({
    required this.id,
    required this.name,
    required this.image,
    required this.level,
    required this.kdKelas,
    required this.progress,
    required this.nav,
  });

  // Convert ke Map (berguna nanti untuk simpan di DB / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'level': level,
      'kdKelas': kdKelas,
      'progress': progress,
      'nav': nav,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      level: map['level'],
      kdKelas: map['kdKelas'],
      progress: map['progress'],
      nav: map['nav'],
    );
  }
}
