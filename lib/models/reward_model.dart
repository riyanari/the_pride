class RewardModel {
  final String name;
  final String imagePath;
  final int points;
  final int sold;
  final String description; // ✅ Tambahkan field ini
  final List<String> spesifikasi; // ✅ Tambahkan field spesifikasi

  RewardModel({
    required this.name,
    required this.imagePath,
    required this.points,
    required this.sold,
    required this.description, // ✅ required juga
    required this.spesifikasi, // ✅ required
  });
}
