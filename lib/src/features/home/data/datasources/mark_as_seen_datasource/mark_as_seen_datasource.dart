import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IMarkAsSeenDatasource {
  Future<Either<AppException, void>> call(String docId);
}
