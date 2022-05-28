import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:talking/src/core/others/app_exception.dart';

abstract class IUpdateOnlineStatusRepository {
  Future<Either<AppException, String>> call(AppLifecycleState state);
}
