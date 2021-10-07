import 'package:flutter/cupertino.dart';
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
  bool isDragging = false;
  bool isEmpty = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    context.read<OnNotifyClick>().newNotification(1); //refresh
    notificationItems.insert(
        0, NotificationItem(icon: Icons.circle, title: 'gg'));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          context.read<OnNotifyClick>().newNotification(0);
          return true;
        },
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            return;
          },
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            appBar: AppBar(
              title: Text('通知'),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: AbsorbPointer(
                absorbing: isDragging,
                child: Drawer(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    header: WaterDropHeader(),
                    child: isEmpty
                        ? Container(
                            child: Center(
                              child: Text(
                                '目前沒有通知',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              bool isNewNotification = false;
                              if (index <
                                  Provider.of<OnNotifyClick>(context,
                                          listen: false)
                                      .newNotifications) {
                                isNewNotification = true;
                              }
                              return Dismissible(
                                resizeDuration: Duration(milliseconds: 100),
                                movementDuration: Duration(milliseconds: 150),
                                background: buildSwipeActionLeft(),
                                secondaryBackground: buildSwipeActionRight(),
                                onDismissed: (direction) {
                                  setState(() {
                                    isDragging = true;
                                    notificationItems.removeAt(index);
                                    if (index <
                                        Provider.of<OnNotifyClick>(context,
                                                listen: false)
                                            .newNotifications) {
                                      context
                                          .read<OnNotifyClick>()
                                          .newNotification(
                                              Provider.of<OnNotifyClick>(
                                                          context,
                                                          listen: false)
                                                      .newNotifications -
                                                  1);
                                    }
                                    Future.delayed(Duration(milliseconds: 150),
                                        () {
                                      setState(() {
                                        isDragging = false;
                                      });
                                    });
                                  });
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
                                          title: Text(
                                              notificationItems[index].title),
                                          onTap: () {},
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
                                ),
                              );
                            },
                            itemCount: notificationItems.length),
                  ),
                ),
              ),
            ),
          ),
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
