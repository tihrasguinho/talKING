import 'package:dartz/dartz.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class MarkAsSeenUsecaseImp implements IMarkAsSeenUsecase {
  final IMarkAsSeenRepository _repository;

  MarkAsSeenUsecaseImp(this._repository);

  @override
  Future<Either<AppException, void>> call(String docId) async {
    if (docId.isEmpty) {
      return Left(AppException(error: 'Document ID is not valid!'));
    }

    return await _repository(docId);
  }
}
