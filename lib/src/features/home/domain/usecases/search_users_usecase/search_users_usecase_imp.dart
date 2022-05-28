import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

class SearchUsersUsecaseImp implements ISearchUsersUsecase {
  final ISearchUsersRepository _repository;

  SearchUsersUsecaseImp(this._repository);

  @override
  Future<Either<AppException, List<UserEntity>>> call(String query) async {
    return await _repository(query);
  }
}
