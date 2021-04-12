import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/src/common/styles.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _msgController = new TextEditingController();
  String _msg = '';

  submitMsg(msg) {
    if (msg != '') {
      _msgController.text = '';
      print(msg);
    }
  }

  @override
  void initState() {
    super.initState();
    _msgController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(),
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
                      color: colorPrimary,
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
}
