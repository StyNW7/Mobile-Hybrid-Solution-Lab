class Student {
  final int id;
  final String name;
  final String major;
  final String? imageUrl;

  Student({
    required this.id,
    required this.name,
    required this.major,
    this.imageUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      major: json['major'],
      imageUrl: json['image_url'],
    );
  }
}