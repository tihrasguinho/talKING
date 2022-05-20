import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/auth/auth_module.dart';

class MainModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AuthModule()),
      ];
}
