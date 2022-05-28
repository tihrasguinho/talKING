import 'package:dartz/dartz.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/others/app_exception.dart';

class MarkAsSeenRepositoryImp implements IMarkAsSeenRepository {
  final IMarkAsSeenDatasource _datasource;

  MarkAsSeenRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, void>> call(String docId) async {
    return await _datasource(docId);
  }
}
