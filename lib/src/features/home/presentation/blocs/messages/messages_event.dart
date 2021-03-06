import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessagesEvent {}

class InitialMessagesEvent extends MessagesEvent {
  final String friendUid;

  InitialMessagesEvent(this.friendUid);
}

class FetchMessagesEvent extends MessagesEvent {
  final String friendUid;

  FetchMessagesEvent(this.friendUid);
}

class LoadMessagesEvent extends MessagesEvent {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  LoadMessagesEvent(this.docs);
}
