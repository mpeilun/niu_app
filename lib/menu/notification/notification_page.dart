import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationDrawer extends StatefulWidget {
  NotificationDrawer({Key? key}) : super(key: key);

  @override
  _NotificationDrawer createState() => new _NotificationDrawer();
}

class _NotificationDrawer extends State<NotificationDrawer> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _onRefresh();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _onRefresh();
  // }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    context.read<OnNotifyClick>().newNotification(5); //refresh
    notificationItems.insert(
        0, NotificationItem(icon: Icons.circle, title: 'gg'));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: WaterDropHeader(),
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                bool newNotify = false;
                if (index < context.watch<OnNotifyClick>().newNotifications) {
                  newNotify = true;
                }
                return Dismissible(
                  background: buildSwipeActionLeft(),
                  secondaryBackground: buildSwipeActionRight(),
                  onDismissed: (direction) {
                    notificationItems.removeAt(index);
                  },
                  key: UniqueKey(),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ListTile(
                            leading: Icon(
                              notificationItems[index].icon,
                              size: 40.0,
                            ),
                            title: Text(notificationItems[index].title),
                            onTap: () {},
                          ),
                          Positioned(
                            top: 6.0,
                            left: 8.0,
                            child: Icon(Icons.brightness_1,
                                color:
                                    newNotify ? Colors.red : Colors.transparent,
                                size: 9.0),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1.2,
                        height: .0,
                      )
                    ],
                  ),
                );
              },
              itemCount: notificationItems.length),
        ),
      ),
    );
  }

  Widget buildSwipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: Icon(FontAwesomeIcons.trashAlt),
      );

  Widget buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: Icon(FontAwesomeIcons.trashAlt),
      );
}
