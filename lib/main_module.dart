import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/guards/auth_guard.dart';
import 'package:talking/src/core/guards/home_guard.dart';
import 'package:talking/src/core/services/firebase_service.dart';
import 'package:talking/src/core/services/i_service.dart';
import 'package:talking/src/features/auth/auth_module.dart';
import 'package:talking/src/features/home/home_module.dart';

class MainModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<IService>((i) => FirebaseService()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          '/',
          module: HomeModule(),
          guards: [
            HomeGuard(),
          ],
        ),
        ModuleRoute(
          '/auth',
          module: AuthModule(),
          guards: [
            AuthGuard(),
          ],
        ),
      ];
}
