import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentFormPage(),
    );
  }
}

class Student {
  final String name;
  final String gender;
  final DateTime birthDate;
  final double skillLevel;

  Student({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.skillLevel,
  });
}

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  String _selectedGender = 'Male';
  bool _agree = false;
  bool _notification = false;
  DateTime? _selectedDate;
  double _skillLevel = 0;

  List<Student> students = [];

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agree && _selectedDate != null) {
      setState(() {
        students.add(
          Student(
            name: _nameController.text,
            gender: _selectedGender,
            birthDate: _selectedDate!,
            skillLevel: _skillLevel,
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student Added Successfully!')),
      );

      _nameController.clear();
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Error"),
          content: Text("Please complete all required fields!"),
        ),
      );
    }
  }

  void _showStudentDetail(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Student Detail"),
        content: Text(
          "Name: ${student.name}\n"
          "Gender: ${student.gender}\n"
          "Skill Level: ${student.skillLevel.toStringAsFixed(0)}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ================= FORM =================
            Form(
              key: _formKey,
              child: Column(
                children: [

                  /// Text Input
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Name cannot be empty" : null,
                  ),

                  const SizedBox(height: 16),

                  /// Dropdown
                  DropdownButtonFormField(
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Date Picker
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "Select Birth Date"
                              : _selectedDate.toString().split(" ")[0],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: const Text("Pick Date"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Skill Level: ${_skillLevel.toStringAsFixed(0)}"),
                      Slider(
                        value: _skillLevel,
                        min: 0,
                        max: 100,
                        divisions: 10,
                        label: _skillLevel.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() {
                            _skillLevel = value;
                          });
                        },
                      ),
                    ],
                  ),

                  /// Checkbox
                  CheckboxListTile(
                    title: const Text("Agree to Terms"),
                    value: _agree,
                    onChanged: (value) {
                      setState(() {
                        _agree = value!;
                      });
                    },
                  ),

                  /// Switch
                  SwitchListTile(
                    title: const Text("Enable Notification"),
                    value: _notification,
                    onChanged: (value) {
                      setState(() {
                        _notification = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ================= LISTVIEW =================
            const Text(
              "Registered Students",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text(student.gender),
                    onTap: () => _showStudentDetail(student),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ================= GRIDVIEW =================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  color: Colors.blue[100],
                  child: Center(
                    child: Text(student.name),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}