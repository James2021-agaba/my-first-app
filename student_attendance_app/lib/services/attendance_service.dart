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
