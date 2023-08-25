class Conversation{
  String id;
  String fullName;
  String profilePic;
  String lastMessage;
  int numberOfUnseenMessages;
  String userId;
  DateTime date;
  DateTime lastSavedConversationDate;
  String email;
  String username;

  Conversation({required this.username, required this.email, required this.id, required this.fullName, required this.lastMessage, required this.profilePic, required this.numberOfUnseenMessages, required this.userId, required this.date, required this.lastSavedConversationDate});
}