import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_state.dart';

class FriendsBloc {
  final IGetFriendsUsecase _getFriendsUsecase;

  final _controller = BehaviorSubject<FriendsEvent>.seeded(FetchFriendsEvent());

  FriendsBloc(this._getFriendsUsecase);

  void emit(FriendsEvent event) => _controller.sink.add(event);

  Stream<FriendsState> get stream => _controller.stream.switchMap(_mapEventToState);

  Stream<FriendsState> _mapEventToState(FriendsEvent event) async* {
    if (event is FetchFriendsEvent) {
      log('FetchFriendsEvent', name: 'FriendsBloc');

      final result = await _getFriendsUsecase();

      if (result.isRight()) {
        final friends = result.getOrElse(() => []);

        for (var friend in friends) {
          await Hive.box<UserEntity>('friends').put(friend.uid, friend);
        }

        yield SuccessFriendsState(friends);
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        yield ErrorFriendsState(exception.error);
      }
    } else if (event is InitialFriendsEvent) {
      log('InitialFriendsEvent', name: 'FriendsBloc');

      yield SuccessFriendsState(Hive.box<UserEntity>('friends').values.toList());
    }
  }

  void dispose() {
    _controller.close();
  }
}
