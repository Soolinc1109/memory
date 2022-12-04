import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart' as intl;
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/stylists.dart';

import '../../model/message.dart';

class TalkRoom extends StatefulWidget {
  final String name;
  final String talkRoomId;
  const TalkRoom(this.name, this.talkRoomId, {Key? key}) : super(key: key);

  @override
  State<TalkRoom> createState() => _TalkRoomState();
}

class _TalkRoomState extends State<TalkRoom> {
  Account myAccount = Authentication.myAccount!;
  List<Message>? messageList = [];
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: StreamBuilder<List<Message>>(
                  stream: StylistFirestore.subscribeMessages(
                      widget.talkRoomId, myAccount.id!),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    messageList = snapshot.data!;
                    return ListView.builder(
                      // physics: const RangeMaintainingScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messageList!.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 10.0,
                              left: 10,
                              right: 10,
                              bottom: index == 0 ? 10 : 0),
                          child: Row(
                            textDirection: messageList![index].isMe
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            children: [
                              Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  decoration: BoxDecoration(
                                      color: messageList![index].isMe
                                          ? Color.fromARGB(255, 255, 142, 210)
                                          : Color.fromARGB(255, 255, 228, 160),
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Text(messageList![index].message)),
                              Text(intl.DateFormat('HH:mm')
                                  .format(messageList![index].sendTime!)),
                            ],
                          ),
                        );
                      }),
                    );
                  }),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.amber,
                  height: 60,
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'Aa',
                          hintStyle: TextStyle(fontSize: 13),
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                    IconButton(
                        onPressed: () {
                          final message = Message(
                            message: textController.text,
                            sendTime: (Timestamp.now()).toDate(),
                          );

                          StylistFirestore.makeMessage(myAccount.id!, message, widget.talkRoomId);
                        },
                        icon: Icon(Icons.send))
                  ]),
                ),
                Container(
                  color: Colors.amber,
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            )
          ],
        ));
  }
}
