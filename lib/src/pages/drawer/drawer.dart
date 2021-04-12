import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/src/common/styles.dart';
import 'package:flutter_chat_socket/src/pages/drawer/widgets/friend_card.dart';
import 'package:flutter_chat_socket/src/repository/friend_repository.dart';
import 'package:flutter_chat_socket/src/repository/group_repository.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DrawerLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerLayoutState();
}

class _DrawerLayoutState extends State<DrawerLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: ListView(
        children: [
          Padding(
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
                          image: NetworkImage(
                              'https://avatars.githubusercontent.com/u/60530946?v=4'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'lambiengcode',
                          style: TextStyle(
                            color: colorTitle,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'I\'m a Mobile App Developer',
                          style: TextStyle(
                            color: colorDarkGrey,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => null,
                  icon: Icon(
                    Feather.sun,
                    color: colorPrimary,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: .2,
            height: .2,
            color: colorDarkGrey,
          ),
          SizedBox(height: 16.0),
          _buildTitle('Active Friends'),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FriendCard(
                name: friends[index]['name'],
                image: friends[index]['image'],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Divider(
              thickness: .1,
              height: .1,
              color: colorDarkGrey,
            ),
          ),
          _buildTitle('Groups'),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return FriendCard(
                name: groups[index]['name'],
                image: groups[index]['image'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorTitle,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'View All',
            style: TextStyle(
              color: colorPrimary,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
