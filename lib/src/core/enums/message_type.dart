enum MessageType {
  text(0, 'text'),
  image(1, 'image'),
  audio(2, 'audio'),
  video(3, 'video');

  final int id;
  final String desc;

  const MessageType(this.id, this.desc);
}
