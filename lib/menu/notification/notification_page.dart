import 'package:flutter/material.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class NotificationDrawer extends StatefulWidget {
  NotificationDrawer({Key? key}) : super(key: key);

  @override
  _NotificationDrawer createState() => new _NotificationDrawer();
}

class _NotificationDrawer extends State<NotificationDrawer> {
  List<NotificationItem> notificationItems = [
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中"離散數學"有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中{離散數學}有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中[離散數學]有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中【離散數學】有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中「離散數學」有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中『離散數學』有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
    NotificationItem(icon: MenuIcon.icon_eschool, title: '在【數位園區】中離散數學有了新的作業'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(
                        notificationItems[index].icon,
                        size: 40.0,
                      ),
                      title: Text(notificationItems[index].title),
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1.0,
                      height: .0,
                    );
                  },
                  itemCount: 15),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 35.0,
                        color: Colors.white,
                      )),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        FontAwesomeIcons.trashAlt,
                        size: 24.0,
                        color: Colors.white,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final String title;

  NotificationItem({
    required this.icon,
    required this.title,
  });
}
