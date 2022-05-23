import 'package:dartz/dartz.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/data/datasources/get_messages_datasource/get_messages_datasource.dart';
import 'package:talking/src/features/home/domain/entities/message_entity.dart';
import 'package:talking/src/features/home/domain/repositories/get_messages_repository.dart';

class GetMessagesRepositoryImp implements IGetMessagesRepository {
  final IGetMessagesDatasource _datasource;

  GetMessagesRepositoryImp(this._datasource);

  @override
  Future<Either<AppException, List<MessageEntity>>> call(String friendUid) async {
    return await _datasource(friendUid);
  }
}
