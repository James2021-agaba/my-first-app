import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:student_attendance_app/models/student_model.dart';
import 'package:student_attendance_app/services/attendance_service.dart';

void main() {
  group('AttendanceService', () {
    // Create a fake FirebaseFirestore instance.
    final firestore = FakeFirebaseFirestore();
    // Create an instance of the AttendanceService with the fake FirebaseFirestore instance.
    final attendanceService = AttendanceService(firestore: firestore);

    // Add some dummy student data to the fake Firestore instance.
    firestore.collection('students').add({'name': 'John Doe'});
    firestore.collection('students').add({'name': 'Jane Smith'});

    test('getStudents returns a list of students', () async {
      // Get the students.
      final students = await attendanceService.getStudents();
      // Check that the list of students is not empty.
      expect(students, isNotEmpty);
      expect(students.length, 2);
    });

    test('saveAttendance saves attendance data', () async {
      // Create a list of students.
      final students = [
        Student(id: '1', name: 'John Doe', isPresent: true),
        Student(id: '2', name: 'Jane Smith', isPresent: false),
      ];
      // Save the attendance data.
      await attendanceService.saveAttendance(students);
      // Get the attendance data from the fake Firestore instance.
      final now = DateTime.now();
      final date = '${now.year}-${now.month}-${now.day}';
      final snapshot = await firestore.collection('attendance').doc(date).get();
      // Check that the data was saved correctly.
      expect(snapshot.exists, isTrue);
      final data = snapshot.data();
      expect(data, isNotNull);
      final savedStudents = data!['students'] as List<dynamic>;
      expect(savedStudents.length, 2);
      expect(savedStudents[0]['isPresent'], isTrue);
      expect(savedStudents[1]['isPresent'], isFalse);
    });
  });
}
