import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/main.dart';
import 'package:flutter_chat_socket/src/common/styles.dart';
import 'package:flutter_chat_socket/src/pages/drawer/drawer.dart';
import 'package:flutter_chat_socket/src/services/socket_service.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SocketService socketService = injector.get<SocketService>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _msgController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  String _msg = '';
  bool _flagTyping = false;

  submitMsg(msg) {
    if (msg != '') {
      socketService.sendMessage(msg);
      socketService.isTyping(false);
      setState(() {
        _msgController.text = '';
        _msg = '';
        _flagTyping = false;
      });
    }
    _focusNode.requestFocus();
  }

  openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    _msgController.text = '';
    //_focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: width * .4,
        child: Drawer(
          child: DrawerLayout(),
        ),
      ),
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: mC,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => null,
          icon: Icon(
            Feather.arrow_left,
            color: colorPrimary,
            size: 22.5,
          ),
        ),
        title: StreamBuilder(
          stream: socketService.getUserInfo,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return Row(
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data['name'],
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
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: Icon(
              Feather.phone,
              size: 22.5,
              color: colorPrimary,
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            onPressed: () => null,
            icon: Icon(
              Feather.video,
              size: 22.5,
              color: colorPrimary,
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            onPressed: () => openDrawer(),
            icon: Icon(
              Feather.sidebar,
              size: 22.5,
              color: colorPrimary,
            ),
          ),
        ],
      ),
      body: Container(
        color: mC,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: socketService.getResponse,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 12.0),
                    controller: socketService.getScrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: snapshot.data[index]['id'] == myId
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            _buildMsgLine(
                              snapshot.data[index]['msg'],
                              snapshot.data[index]['id'] == myId,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              alignment: Alignment.centerLeft,
              child: StreamBuilder(
                stream: socketService.getTyping,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Text(
                    snapshot.data['isTyping']
                        ? '${snapshot.data['name']} is typing...'
                        : '',
                    style: TextStyle(
                      color: colorPrimary,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: .1,
              thickness: .1,
              color: colorDarkGrey,
            ),
            Container(
              height: 75.0,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        color: mC,
                        boxShadow: [
                          BoxShadow(
                            color: mCD,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                          BoxShadow(
                            color: mCL,
                            offset: Offset(-2, -2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        autofocus: true,
                        focusNode: _focusNode,
                        controller: _msgController,
                        onFieldSubmitted: (val) => submitMsg(val),
                        cursorColor: fCL,
                        cursorRadius: Radius.circular(30.0),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: fCL,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (val.length == 0) {
                              if (_flagTyping) {
                                socketService.isTyping(false);
                                _flagTyping = false;
                              }
                            } else {
                              if (_flagTyping == false) {
                                socketService.isTyping(true);
                                _flagTyping = true;
                              }
                            }
                            _msg = val.trim();
                          });
                        },
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            bottom: .0,
                            left: 24.0,
                          ),
                          border: InputBorder.none,
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: fCL,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => submitMsg(_msg),
                    icon: Icon(
                      Feather.send,
                      color: _msg.length == 0 ? fCD : colorPrimary,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMsgLine(msg, isMe) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 26.0,
        vertical: 14.0,
      ),
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: isMe ? colorPrimary : mC,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: mCD,
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: mCL,
            offset: Offset(-2, -2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            msg,
            style: TextStyle(
              color: isMe ? mCL : colorTitle,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
