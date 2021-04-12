import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/main.dart';
import 'package:flutter_chat_socket/src/common/styles.dart';
import 'package:flutter_chat_socket/src/services/socket_service.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class FriendCard extends StatefulWidget {
  final String name;
  final String image;
  FriendCard({this.name, this.image});
  @override
  State<StatefulWidget> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  final SocketService socketService = injector.get<SocketService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 46.0,
                width: 46.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: colorTitle,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Active Now',
                    style: TextStyle(
                      color: Colors.green.shade400,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              socketService.setUserInfo(
                {
                  'name': widget.name,
                  'image': widget.image,
                },
              );
              Get.back();
            },
            icon: Icon(
              Feather.message_square,
              color: colorPrimary,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
