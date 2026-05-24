import 'dart:convert';
import 'dart:typed_data';

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
  final nameController = TextEditingController();
  final majorController = TextEditingController();
  final picker = ImagePicker();

  List<Student> students = [];
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  void dispose() {
    nameController.dispose();
    majorController.dispose();
    super.dispose();
  }

  Future<void> loadStudents() async {
    setState(() => isLoading = true);

    try {
      final result = await StudentService.fetchStudents();

      if (!mounted) return;

      setState(() {
        students = result;
      });
    } catch (e) {
      showSnackBar(e.toString());
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> addStudent() async {
    final name = nameController.text.trim();
    final major = majorController.text.trim();

    if (name.isEmpty || major.isEmpty) {
      showSnackBar('Name and major are required');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await StudentService.createStudent(
        name: name,
        major: major,
      );

      nameController.clear();
      majorController.clear();

      showSnackBar('Student added successfully');
      await loadStudents();
    } catch (e) {
      showSnackBar(e.toString());
    }

    if (!mounted) return;
    setState(() => isSubmitting = false);
  }

  Future<void> uploadStudentImage(int studentId) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 600,
    );

    if (picked == null) return;

    try {
      await StudentService.uploadImage(
        studentId: studentId,
        imageFile: picked,
      );

      showSnackBar('Image uploaded successfully');
      await loadStudents();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  ImageProvider? getStudentImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    try {
      if (imageUrl.startsWith('data:image')) {
        final base64String = imageUrl.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      }

      if (imageUrl.startsWith('http')) {
        return NetworkImage(imageUrl);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  void showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildStudentCard(Student student) {
    final imageProvider = getStudentImage(student.imageUrl);
    final firstLetter = student.name.isNotEmpty
        ? student.name[0].toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.indigo.shade100,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Text(
                      firstLetter,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    student.major,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  if (student.imageUrl != null &&
                      student.imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      student.imageUrl!.startsWith('data:image')
                          ? 'Profile image uploaded'
                          : student.imageUrl!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.indigo.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            IconButton(
              tooltip: 'Upload Image',
              onPressed: () => uploadStudentImage(student.id),
              icon: const Icon(Icons.cloud_upload_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade600,
            Colors.indigo.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(height: 16),
          Text(
            'Student API Integration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Flutter Web + Express API + Supabase PostgreSQL',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: majorController,
              decoration: const InputDecoration(
                labelText: 'Major',
                prefixIcon: Icon(Icons.menu_book_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: isSubmitting ? null : addStudent,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(
                  isSubmitting ? 'Adding...' : 'Add Student',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStudentList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text('No students found'),
        ),
      );
    }

    return Column(
      children: students.map(buildStudentCard).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        title: const Text('Student Project'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                buildHeader(),
                const SizedBox(height: 18),
                buildForm(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      'Registered Students',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('${students.length} data'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildStudentList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}