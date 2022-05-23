import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/core/params/send_message_params.dart';
import 'package:talking/src/features/home/data/datasources/send_message_datasource/send_message_datasource.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/repositories/send_message_repository.dart';

class SendMessageRepositoryImp implements ISendMessageRepository {
  final ISendMessageDatasource _datasource;

  SendMessageRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, MessageEntity>> call(SendMessageParams params) async {
    return await _datasource(params);
  }
}
