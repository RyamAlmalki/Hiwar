class Conversation{
  String id;
  String fullName;
  String profilePic;
  String lastMessage;
  int numberOfUnseenMessages;

  Conversation({required this.id, required this.fullName, required this.lastMessage, required this.profilePic, required this.numberOfUnseenMessages});
}