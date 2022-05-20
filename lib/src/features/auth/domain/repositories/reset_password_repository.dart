import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IResetPasswordRepository {
  Future<Either<AppException, String>> call(String email);
}
