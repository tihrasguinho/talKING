import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:talking/src/features/home/data/datasources/search_users_datasource/search_users_datasource.dart';
import 'package:talking/src/features/home/domain/repositories/search_users_repository.dart';

class SearchUsersRepositoryImp implements ISearchUsersRepository {
  final ISearchUsersDatasource _datasource;

  SearchUsersRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, List<UserEntity>>> call(String query) async {
    return await _datasource(query);
  }
}
