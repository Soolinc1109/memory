import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  bool isMe;
  DateTime? sendTime;

  Message({
    this.message = '',
    this.isMe = true,
    this.sendTime,
  });
}
