import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IUpdateTypingToUsecase {
  Future<Either<AppException, void>> call(String friendUid);
}
