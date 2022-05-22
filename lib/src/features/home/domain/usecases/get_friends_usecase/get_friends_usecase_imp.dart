import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/domain/repositories/get_friends_repository.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';

class GetFriendsUsecaseImp implements IGetFriendsUsecase {
  final IGetFriendsRepository _repository;

  GetFriendsUsecaseImp(this._repository);

  @override
  Future<Either<AppException, List<UserEntity>>> call() async {
    return await _repository();
  }
}
