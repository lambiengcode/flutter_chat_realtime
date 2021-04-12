import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/src/repository/friend_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  final _socketResponse = StreamController<List<dynamic>>();
  final _userInfo = StreamController<dynamic>();
  final _scrollController = ScrollController();
  List<dynamic> allMessage = [];
  IO.Socket socket;

  createSocketConnection() {
    this.socket = IO.io('http://localhost:3000/',
        IO.OptionBuilder().setTransports(['websocket']).build());
    this.socket.connect();
    this.socket.onConnect((_) {
      print(socket.connected);
      this.socket.emit('join', '18110239');
    });

    //When an event recieved from server, data is added to the stream
    this.socket.on('room', (data) {
      allMessage.add(data);
      _socketResponse.add(allMessage);
      scrollToBottom();
    });
    this.socket.onDisconnect((_) => print('disconnect'));
    _userInfo.add(friends[0]);
  }

  sendMessage(msg) {
    this.socket.emit('room', msg.toString());
  }

  void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;

  Stream<List<dynamic>> get getResponse => _socketResponse.stream;

  ScrollController get getScrollController => _scrollController;

  void setUserInfo(dynamic info) => _userInfo.add(info);

  Stream<dynamic> get getUserInfo => _userInfo.stream;

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80.0,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 100),
      );
    }
  }

  void dispose() {
    _socketResponse.close();
  }
}
