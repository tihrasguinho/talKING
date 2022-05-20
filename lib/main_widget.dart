import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talking/src/core/others/app_consts.dart';
import 'package:talking/src/core/utils/navigator_key.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Modular.setNavigatorKey(navigatorKey);

    return MaterialApp.router(
      title: 'talKING',
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      theme: FlexThemeData.dark(
        colorScheme: AppConsts.flexSchemeDark,
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: FlexThemeData.dark(
        colorScheme: AppConsts.flexSchemeDark,
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
