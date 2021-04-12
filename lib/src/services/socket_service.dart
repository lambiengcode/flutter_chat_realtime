import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  final _socketResponse = StreamController<String>();
  IO.Socket socket;

  createSocketConnection() {
    this.socket = IO.io('http://localhost:3000/',
        IO.OptionBuilder().setTransports(['websocket']).build());
    this.socket.connect();
    this.socket.onConnect((_) {
      print('connect');
      this.socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    this.socket.on('event', (data) => streamSocket.addResponse);
    this.socket.onDisconnect((_) => print('disconnect'));
    print(socket.connected);
  }

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

SocketService streamSocket = SocketService();
