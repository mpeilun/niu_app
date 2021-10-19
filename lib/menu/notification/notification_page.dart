import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notification_webview.dart';

class NotificationDrawer extends StatefulWidget {
  NotificationDrawer({Key? key}) : super(key: key);

  @override
  _NotificationDrawer createState() => new _NotificationDrawer();
}

class _NotificationDrawer extends State<NotificationDrawer>
    with SingleTickerProviderStateMixin {
  late List<NotificationItem> notificationItems;
  List<IconData> iconList = [MenuIcon.icon_e_school, Icons.blur_on];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await runNotificationWebViewWebView(context, _refreshController);
  }

  void clearAllItems() async {
    notificationItems.clear();
    context
        .read<NotificationProvider>()
        .setNotificationItemList(notificationItems);
    context.read<NotificationProvider>().setNewNotificationsCount(0);
    context.read<NotificationProvider>().setIsEmpty(true);
  }

  @override
  void initState() {
    notificationItems =
        context.read<NotificationProvider>().notificationItemList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        context.read<NotificationProvider>().setNewNotificationsCount(0);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Text('通知'),
          actions: [
            PopupMenuButton(
              onSelected: (result) {
                if (result == 0) {
                  clearAllItems();
                }
              },
              icon: Icon(Icons.more_vert_outlined),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 0,
                  child: Align(child: Text('清除全部')),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: WaterDropHeader(),
            child: context.watch<NotificationProvider>().isEmpty
                ? Container(
                    child: Center(
                      child: Text(
                        '目前沒有通知',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notificationItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isNewNotification = false;
                      if (index <
                          Provider.of<NotificationProvider>(context,
                                  listen: false)
                              .newNotificationsCount) {
                        isNewNotification = true;
                      }
                      return Dismissible(
                          resizeDuration: Duration(milliseconds: 100),
                          movementDuration: Duration(milliseconds: 150),
                          background: buildSwipeActionLeft(),
                          secondaryBackground: buildSwipeActionRight(),
                          onDismissed: (direction) {
                            context
                                .read<NotificationProvider>()
                                .dissmisible(index);
                            isNewNotification = false;
                          },
                          key: UniqueKey(),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      iconList[
                                          notificationItems[index].icon],
                                      size: 40.0,
                                    ),
                                    title: Text(
                                        notificationItems[index].title),
                                    onTap: () {
                                      isNewNotification = false;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ESchool(),
                                              maintainState: false));
                                    },
                                  ),
                                  Positioned(
                                    top: 6.0,
                                    left: 8.0,
                                    child: Icon(Icons.brightness_1,
                                        color: isNewNotification
                                            ? Colors.red
                                            : Colors.transparent,
                                        size: 9.0),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 1.2,
                                height: .0,
                              )
                            ],
                          ));
                    },
                  ),
          ),
        ),
      ),
    ));
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
