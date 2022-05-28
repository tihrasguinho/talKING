import 'package:dartz/dartz.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/others/app_exception.dart';

class DeleteMessageRepositoryImp implements IDeleteMessageRepository {
  final IDeleteMessageDatasource _datasource;

  DeleteMessageRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, bool>> call(MessageEntity message) async {
    return await _datasource(message);
  }
}
