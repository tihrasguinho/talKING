import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';

class FriendsBloc extends ValueNotifier<List<UserEntity>> {
  final IGetFriendsUsecase _getFriendsUsecase;

  FriendsBloc(this._getFriendsUsecase) : super([]) {
    emit(HiveFriendsEvent());
  }

  void emit(FriendsEvent event) async {
    if (event is FetchFriendsEvent) {
      log('FetchFriendsEvent');

      final result = await _getFriendsUsecase();

      if (result.isRight()) {
        final friends = result.getOrElse(() => []);

        for (var friend in friends) {
          await Hive.box<UserEntity>('friends').put(friend.uid, friend);
        }

        value = friends;
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        log(exception.error);

        value = [];
      }
    } else if (event is HiveFriendsEvent) {
      log('HiveFriendsEvent');

      value = Hive.box<UserEntity>('friends').values.toList();
    }
  }

  List<UserEntity> get friends {
    final data = value;

    return data;
  }
}
