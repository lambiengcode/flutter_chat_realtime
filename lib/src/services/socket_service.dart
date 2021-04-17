import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/src/common/styles.dart';
import 'package:flutter_chat_socket/src/repository/friend_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  final _socketResponse = StreamController<List<dynamic>>();
  final _typingController = StreamController<dynamic>();
  final _userController = StreamController<dynamic>();
  final _scrollController = ScrollController();
  var _userInfo, _room = 'Selena';
  List<dynamic> _allMessage = [];
  IO.Socket socket;

  createSocketConnection() {
    _userController.add(friends[0]);
    _userInfo = friends[0];
    this.socket = IO.io('http://localhost:3000/',
        IO.OptionBuilder().setTransports(['websocket']).build());
    this.socket.connect();
    this.socket.onConnect((_) {
      this.socket.emit('join', myId);
      // Join room
      this.socket.emit('subscribe', _room);

      subscribe();
    });

    this.socket.onDisconnect((_) => print('disconnect'));
  }

  subscribe() {
    this.socket.on('$myId-$_room-history', (data) {
      _allMessage.clear();
      _allMessage.addAll(data);
      _allMessage = _allMessage.reversed.toList();
      _socketResponse.add(_allMessage);
      scrollToBottom();
    });

    this.socket.on(_room, (data) {
      _allMessage.insert(0, data);
      _socketResponse.add(_allMessage);
      scrollToBottom();
    });

    this.socket.on('$_room-typing', (data) {
      _typingController.add(data);
    });
  }

  sendMessage(msg) {
    _allMessage.insert(0, {
      'msg': msg,
      'id': myId,
    });
    this.socket.emit(_room, msg.toString());
  }

  isTyping(isTyping) {
    this.socket.emit('$_room-typing', {
      'id': myId,
      'isTyping': isTyping,
      'name': 'lambiengcode',
    });
  }

  void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;

  Stream<List<dynamic>> get getResponse => _socketResponse.stream;

  Stream<dynamic> get getTyping => _typingController.stream;

  ScrollController get getScrollController => _scrollController;

  void setUserInfo(dynamic info) {
    _userController.add(info);
    _userInfo = info;
    _allMessage.clear();
    _socketResponse.add(_allMessage);
    this.socket.emit('unsubscribe', _room);
    _room = info['name'];
    this.socket.emit('subscribe', _room);
    subscribe();
  }

  Stream<dynamic> get getUserInfo => _userController.stream;

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 100),
      );
    }
  }

  void dispose() {
    _socketResponse.close();
    _typingController.close();
    _userController.close();
  }
}
