import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_state.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';

class ChatsController {
  final FriendsBloc _friendsBloc;
  final CurrentUserBloc _currentUserBloc;

  ChatsController(this._friendsBloc, this._currentUserBloc);

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> stream() {
    final friends = _friendsBloc.value.friends;
    final user = (_currentUserBloc.value as SuccessCurrentUserState).user;
    final firestore = FirebaseFirestore.instance;

    final streams = friends
        .map((friend) => firestore
            .collection('cl_messages')
            .where('from', isEqualTo: user.uid)
            .where('to', isEqualTo: friend.uid)
            .orderBy('time')
            .limit(1)
            .snapshots())
        .toList();

    return Rx.combineLatest<QuerySnapshot<Map<String, dynamic>>, List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      streams,
      (values) {
        final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final data = values.fold(docs, (List<QueryDocumentSnapshot<Map<String, dynamic>>> p, e) => [...p, ...e.docs]);

        return data;
      },
    ).asBroadcastStream();
  }
}
