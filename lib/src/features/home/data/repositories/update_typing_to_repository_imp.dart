import 'package:dartz/dartz.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateTypingToRepositoryImp implements IUpdateTypingToRepository {
  final IUpdateTypingToDatasource _datasource;

  UpdateTypingToRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, void>> call(String friendUid) async {
    return await _datasource(friendUid);
  }
}
