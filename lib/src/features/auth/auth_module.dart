import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/auth/data/datasources/reset_password_datasource/reset_password_datasource.dart';
import 'package:talking/src/features/auth/data/datasources/reset_password_datasource/reset_password_firebase_datasource_imp.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_datasource.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_firebase_datasource_imp.dart';
import 'package:talking/src/features/auth/data/datasources/signup_datasource/signup_datasource.dart';
import 'package:talking/src/features/auth/data/datasources/signup_datasource/signup_firebase_datasource_imp.dart';
import 'package:talking/src/features/auth/data/repositories/reset_password_repository_imp.dart';
import 'package:talking/src/features/auth/data/repositories/signin_repository_imp.dart';
import 'package:talking/src/features/auth/data/repositories/signup_repository_imp.dart';
import 'package:talking/src/features/auth/domain/repositories/reset_password_repository.dart';
import 'package:talking/src/features/auth/domain/repositories/signin_repository.dart';
import 'package:talking/src/features/auth/domain/repositories/signup_repository.dart';
import 'package:talking/src/features/auth/domain/usecases/reset_password_usecase/reset_password_usecase.dart';
import 'package:talking/src/features/auth/domain/usecases/reset_password_usecase/reset_password_usecase_imp.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase_imp.dart';
import 'package:talking/src/features/auth/domain/usecases/signup_usecase/signup_usecase.dart';
import 'package:talking/src/features/auth/domain/usecases/signup_usecase/signup_usecase_imp.dart';
import 'package:talking/src/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:talking/src/features/auth/presentation/controllers/signin_controller.dart';
import 'package:talking/src/features/auth/presentation/controllers/signup_controller.dart';
import 'package:talking/src/features/auth/presentation/pages/reset_password_page.dart';

import 'presentation/pages/signin_page.dart';
import 'presentation/pages/signup_page.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Sign In

        Bind.lazySingleton<ISigninDatasource>((i) => SigninFirebaseDatasourceImp()),
        Bind.lazySingleton<ISigninRepository>((i) => SigninRepositoryImp(i())),
        Bind.lazySingleton<ISigninUsecase>((i) => SigninUsecaseImp(i())),
        Bind.factory<SigninController>((i) => SigninController(i())),

        // Sign Up

        Bind.lazySingleton<ISignupDatasource>((i) => SignupFirebaseDatasourceImp()),
        Bind.lazySingleton<ISignupRepository>((i) => SignupRepositoryImp(i())),
        Bind.lazySingleton<ISignupUsecase>((i) => SignupUsecaseImp(i())),
        Bind.factory<SignupController>((i) => SignupController(i())),

        // Reset Password

        Bind.lazySingleton<IResetPasswordDatasource>((i) => ResetPasswordFirebaseDatasourceImp()),
        Bind.lazySingleton<IResetPasswordRepository>((i) => ResetPasswordRepositoryImp(i())),
        Bind.lazySingleton<IResetPasswordUsecase>((i) => ResetPasswordUsecaseImp(i())),
        Bind.factory<ResetPasswordController>((i) => ResetPasswordController(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const SigninPage()),
        ChildRoute('/signup', child: (_, __) => const SignupPage()),
        ChildRoute('/reset-password', child: (_, __) => const ResetPasswordPage()),
      ];
}
