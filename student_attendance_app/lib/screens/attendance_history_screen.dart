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
}
