import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/student.dart';
import '../services/student_service.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<Student> students = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await StudentService.fetchStudents();

      setState(() {
        students = result;
      });
    } catch (e) {
      showSnackBar('Failed to load students');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addStudent() async {
    final name = nameController.text;
    final major = majorController.text;

    if (name.isEmpty || major.isEmpty) {
      showSnackBar('Name and major are required');
      return;
    }

    try {
      await StudentService.createStudent(
        name: name,
        major: major,
      );

      nameController.clear();
      majorController.clear();

      showSnackBar('Student added successfully');
      loadStudents();
    } catch (e) {
      showSnackBar('Failed to add student');
    }
  }

  Future<void> pickAndUploadImage(int studentId) async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    try {
      await StudentService.uploadImage(
        studentId: studentId,
        imageFile: picked,
      );

      showSnackBar('Image uploaded successfully');
      loadStudents();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildStudentCard(Student student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: student.imageUrl != null
              ? NetworkImage(student.imageUrl!)
              : null,
          child: student.imageUrl == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(student.name),
        subtitle: Text(student.major),
        trailing: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: () => pickAndUploadImage(student.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student API Integration'),
        actions: [
          IconButton(
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: majorController,
              decoration: const InputDecoration(
                labelText: 'Major',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addStudent,
                child: const Text('Add Student'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : students.isEmpty
                      ? const Center(
                          child: Text('No students found'),
                        )
                      : ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            return buildStudentCard(students[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}