import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/data/datasources/get_friends_datasource/get_friends_datasource.dart';
import 'package:talking/src/features/home/domain/repositories/get_friends_repository.dart';

class GetFriendsRepositoryImp implements IGetFriendsRepository {
  final IGetFriendsDatasource _datasource;

  GetFriendsRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, List<UserEntity>>> call() async {
    return await _datasource();
  }
}
