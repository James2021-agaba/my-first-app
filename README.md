import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance_app/services/attendance_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  // Create an instance of the AttendanceService to handle Firestore operations.
  final AttendanceService _attendanceService = AttendanceService();

  // A list to hold the attendance history fetched from Firestore.
  List<Map<String, dynamic>> _attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    // Fetch the attendance history when the screen is initialized.
    _fetchAttendanceHistory();
  }

  // A method to fetch the attendance history from Firestore.
  void _fetchAttendanceHistory() async {
    final history = await _attendanceService.getAttendanceHistory();
    setState(() {
      _attendanceHistory = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: ListView.builder(
        itemCount: _attendanceHistory.length,
        itemBuilder: (context, index) {
          final record = _attendanceHistory[index];
          // Cast the date to a Timestamp and then convert it to a DateTime.
          final date = (record['date'] as Timestamp).toDate();
          final students = record['students'] as List<dynamic>;
          final presentCount = students.where((s) => s['isPresent']).length;
          final absentCount = students.length - presentCount;

          return ListTile(
            title: Text('${date.year}-${date.month}-${date.day}'),
            subtitle: Text('Present: $presentCount, Absent: $absentCount'),
          );
        },
      ),
    );
  }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance_app/models/student_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore;

  // A constructor that accepts an instance of FirebaseFirestore.
  // This allows us to inject a mock instance for testing.
  AttendanceService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // A method to get the list of students from Firestore.
  Future<List<Student>> getStudents() async {
    final snapshot = await _firestore.collection('students').get();
    return snapshot.docs
        .map((doc) => Student.fromMap(doc.data(), doc.id))
        .toList();
  }

  // A method to save the attendance data to Firestore.
  Future<void> saveAttendance(List<Student> students) async {
    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';

    final attendanceData = {
      'date': now,
      'students': students
          .map((student) => {
                'id': student.id,
                'name': student.name,
                'isPresent': student.isPresent,
              })
          .toList(),
    };

    // Save the attendance data to a document with the current date as the ID.
    await _firestore.collection('attendance').doc(date).set(attendanceData);
  }

  // A method to get the attendance history from Firestore.
  Future<List<Map<String, dynamic>>> getAttendanceHistory() async {
    final snapshot = await _firestore
        .collection('attendance')
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

