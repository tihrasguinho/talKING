import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState!;
