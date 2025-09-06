class Student {
  final String id;
  final String name;
  bool isPresent;

  Student({required this.id, required this.name, this.isPresent = false});

  // A factory constructor to create a Student from a Firestore document.
  factory Student.fromMap(Map<String, dynamic> data, String documentId) {
    return Student(
      id: documentId,
      name: data['name'] ?? '',
      isPresent: data['isPresent'] ?? false,
    );
  }

  // A method to convert a Student object to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isPresent': isPresent,
    };
  }
}
