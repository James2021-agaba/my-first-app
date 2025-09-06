import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance_app/models/student_model.dart';
import 'package:student_attendance_app/screens/attendance_history_screen.dart';
import 'package:student_attendance_app/services/attendance_service.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  // Create an instance of the AttendanceService to handle Firestore operations.
  final AttendanceService _attendanceService = AttendanceService();

  // A list to hold the students fetched from Firestore.
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    // Fetch the students when the screen is initialized.
    _fetchStudents();
  }

  // A method to fetch the students from Firestore.
  void _fetchStudents() async {
    final students = await _attendanceService.getStudents();
    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AttendanceHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            title: Text(student.name),
            trailing: Checkbox(
              value: student.isPresent,
              onChanged: (value) {
                setState(() {
                  student.isPresent = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAttendance,
        child: const Icon(Icons.save),
      ),
    );
  }

  // A method to save the attendance data to Firestore.
  void _saveAttendance() async {
    try {
      await _attendanceService.saveAttendance(_students);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving attendance: $e')),
      );
    }
  }
}
