import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/domain/repositories/search_users_repository.dart';
import 'package:talking/src/features/home/domain/usecases/search_users_usecase/search_users_usecase.dart';

class SearchUsersUsecaseImp implements ISearchUsersUsecase {
  final ISearchUsersRepository _repository;

  SearchUsersUsecaseImp(this._repository);

  @override
  Future<Either<AppException, List<UserEntity>>> call(String query) async {
    return await _repository(query);
  }
}
