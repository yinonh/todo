import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ToDoList {
  final String id;
  final String userID;
  final int notificationIndex;
  bool hasDeadline;
  String title;
  DateTime creationDate;
  DateTime deadline;
  int totalItems;
  int accomplishedItems;

  ToDoList({
    required this.id,
    required this.userID,
    required this.notificationIndex,
    required this.hasDeadline,
    required this.title,
    required this.creationDate,
    required this.deadline,
    required this.totalItems,
    required this.accomplishedItems,
  });

  // Method to create a ToDoList object from a DocumentSnapshot
  factory ToDoList.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ToDoList(
      id: snapshot.id,
      userID: data['userID'],
      notificationIndex: data['notificationIndex'],
      hasDeadline: data['hasDeadline'],
      title: data['title'],
      creationDate: DateTime.parse(data['creationDate']),
      deadline: DateTime.parse(data['deadline']),
      totalItems: data['totalItems'],
      accomplishedItems: data['accomplishedItems'],
    );
  }

  // Method to convert a ToDoList object to a Map
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'title': title,
      'notificationIndex': notificationIndex,
      'hasDeadline': hasDeadline,
      'creationDate': DateFormat('yyyy-MM-dd').format(creationDate),
      'deadline': DateFormat('yyyy-MM-dd').format(deadline),
      'totalItems': totalItems,
      'accomplishedItems': accomplishedItems,
    };
  }
}
