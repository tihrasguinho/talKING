import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/src/core/data/dtos/app_dtos.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class MainController {
  final IUpdateOnlineStatusUsecase _updateOnlineStatusUsecase;

  final hive = Hive.box('app');

  MainController(this._updateOnlineStatusUsecase);

  Future<void> updateOnlineStatus(AppLifecycleState state) async {
    final result = await _updateOnlineStatusUsecase(state);

    if (result.isRight()) {
      log(result.getOrElse(() => ''), name: 'UpdateOnlineStatus');
    } else {
      final exception = result.fold((l) => l, (r) => null) as AppException;

      log(exception.error, name: 'UpdateOnlineStatus');
    }
  }

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
      return MessageDto.fromFirestore(doc);
    } else {
      return MessageDto.fromFirestore(doc);
    }
  }
}
