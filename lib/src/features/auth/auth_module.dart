import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';

import 'presentation/controllers/reset_password_controller.dart';
import 'presentation/controllers/signin_controller.dart';
import 'presentation/controllers/signup_controller.dart';
import 'presentation/pages/reset_password_page.dart';
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
