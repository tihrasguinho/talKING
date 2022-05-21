import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/features/home/data/datasources/get_current_user_datasource/get_current_user_datasource.dart';
import 'package:talking/src/features/home/domain/repositories/get_current_user_repository.dart';

class GetCurrentUserRepositoryImp implements IGetCurrentUserRepository {
  final IGetCurrentUserDatasource _datasource;

  GetCurrentUserRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, UserEntity>> call() async {
    return await _datasource();
  }
}
