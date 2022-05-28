import 'package:intl/intl.dart';
import 'package:talking/src/core/domain/entities/app_entities.dart';

extension ChatDto on ChatEntity {
  String get time {
    final date = message.time.toLocal();

    final now = DateTime.now();

    final hours = DateFormat('HH:mm', 'en_US');

    final allDate = DateFormat('dd MMMM yy', 'en_US');

    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return hours.format(date);
    } else if (difference.inDays >= 1 && difference.inDays < 2) {
      return 'Yesterday';
    } else {
      return allDate.format(date);
    }
  }
}
