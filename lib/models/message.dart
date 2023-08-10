class Message{
  DateTime date;
  String? senderId;
  String? message;
  String? senderName;
  String? type;

  Message({ required this.date, this.senderId, this.message, this.senderName, this.type});
}