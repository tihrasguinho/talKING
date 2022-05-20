import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_datasource.dart';
import 'package:talking/src/features/auth/data/datasources/signin_datasource/signin_firebase_datasource_imp.dart';
import 'package:talking/src/features/auth/data/repositories/signin_repository_imp.dart';
import 'package:talking/src/features/auth/domain/repositories/signin_repository.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase.dart';
import 'package:talking/src/features/auth/domain/usecases/signin_usecase/signin_usecase_imp.dart';
import 'package:talking/src/features/auth/presentation/controllers/signin_controller.dart';

import 'presentation/pages/signin_page.dart';
import 'presentation/pages/signup_page.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<ISigninDatasource>((i) => SigninFirebaseDatasourceImp()),
        Bind.lazySingleton<ISigninRepository>((i) => SigninRepositoryImp(i())),
        Bind.lazySingleton<ISigninUsecase>((i) => SigninUsecaseImp(i())),
        Bind.factory<SigninController>((i) => SigninController(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const SigninPage()),
        ChildRoute('/signup', child: (_, __) => const SignupPage()),
      ];
}
