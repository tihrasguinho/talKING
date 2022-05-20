import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/auth/data/datasources/reset_password_datasource/reset_password_datasource.dart';

class ResetPasswordFirebaseDatasourceImp implements IResetPasswordDatasource {
  @override
  Future<Either<AppException, String>> call(String email) async {
    try {
      final auth = FirebaseAuth.instance;

      await auth.sendPasswordResetEmail(email: email);

      return const Right('Email sent!');
    } on FirebaseException catch (e) {
      return Left(AppException(error: e.message ?? '', stackTrace: e.stackTrace));
    } on Exception catch (e) {
      return Left(AppException(error: e.toString()));
    }
  }
}
