enum NotificationType {
  newMessage('new_message'),
  friendRequest('friend_request'),
  friendAccepted('friend_accepted');

  final String value;

  const NotificationType(this.value);
}
