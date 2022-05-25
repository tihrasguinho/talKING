import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LastMessagesEvent {}

class LoadLasMessagesEvent extends LastMessagesEvent {
  final List<QueryDocumentSnapshot> docs;

  LoadLasMessagesEvent(this.docs);
}
