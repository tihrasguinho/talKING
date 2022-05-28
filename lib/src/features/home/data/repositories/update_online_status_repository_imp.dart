import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/others/app_exception.dart';

class UpdateOnlineStatusRepositoryImp implements IUpdateOnlineStatusRepository {
  final IUpdateOnlineStatusDatasource _datasource;

  UpdateOnlineStatusRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, String>> call(AppLifecycleState state) async {
    return await _datasource(state);
  }
}
