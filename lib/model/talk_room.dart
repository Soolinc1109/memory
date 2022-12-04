import 'package:firebase_auth/firebase_auth.dart';

class TalkRoom {
  String roomId;
  User talkUser;
  String lastMessage;

  TalkRoom({
    required this.roomId,
    required this.talkUser,
    this.lastMessage = "",
  });
}
