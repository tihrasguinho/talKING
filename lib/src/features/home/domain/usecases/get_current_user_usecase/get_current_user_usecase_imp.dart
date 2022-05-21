import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/domain/repositories/get_current_user_repository.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase.dart';

class GetCurrentUserUsecaseImp implements IGetCurrentUserUsecase {
  final IGetCurrentUserRepository _repository;

  GetCurrentUserUsecaseImp(this._repository);

  @override
  Future<Either<AppException, UserEntity>> call() async {
    return await _repository();
  }
}
