import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateOnlineStatusUsecaseImp implements IUpdateOnlineStatusUsecase {
  final IUpdateOnlineStatusRepository _repository;

  UpdateOnlineStatusUsecaseImp(this._repository);

  @override
  Future<Either<AppException, String>> call(AppLifecycleState state) async {
    return await _repository(state);
  }
}
