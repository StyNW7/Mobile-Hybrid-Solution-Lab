class Student {
  final int id;
  final String name;
  final String major;
  final String? imageUrl;
  final String? createdAt;

  Student({
    required this.id,
    required this.name,
    required this.major,
    this.imageUrl,
    this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      major: json['major'] ?? '',
      imageUrl: json['image_url'],
      createdAt: json['created_at']?.toString(),
    );
  }
}