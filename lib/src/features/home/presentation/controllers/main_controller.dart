import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/features/home/data/dtos/message_dto.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';

class MainController {
  final hive = Hive.box('app');

  Stream<List<MessageEntity>> stream() {
    final uid = hive.get('uid');

    final from = FirebaseFirestore.instance.collection('cl_messages').where('from', isEqualTo: uid).snapshots();

    final to = FirebaseFirestore.instance.collection('cl_messages').where('to', isEqualTo: uid).snapshots();

    return Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>, QuerySnapshot<Map<String, dynamic>>,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      from,
      to,
      (a, b) => [...a.docs, ...b.docs],
    ).asyncMap((event) => event.map(_firestoreToMessage).toList());
  }

  MessageEntity _firestoreToMessage(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data()['type'] == 'text') {
      return MessageDto.textFromFirestore(doc);
    } else {
      return MessageDto.imageFromFirestore(doc);
    }
  }
}
