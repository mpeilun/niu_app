import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niu_app/components/menuIcon.dart';
import 'package:niu_app/e_school/e_school.dart';
import 'package:niu_app/menu/notification/notificatioon_items.dart';
import 'package:niu_app/provider/notification_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationDrawer extends StatefulWidget {
  NotificationDrawer({Key? key}) : super(key: key);

  @override
  _NotificationDrawer createState() => new _NotificationDrawer();
}

class _NotificationDrawer extends State<NotificationDrawer>
    with SingleTickerProviderStateMixin {
  late List<NotificationItem> notificationItems;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<IconData> iconList = [MenuIcon.icon_e_school, Icons.blur_on];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    context.read<NotificationProvider>().setNewNotificationsCount(1);
    notificationItems.insert(0, NotificationItem(icon: 1, title: 'gg'));
    notificationItems.insert(1, NotificationItem(icon: 1, title: 'gg'));
    notificationItems.insert(2, NotificationItem(icon: 1, title: 'gg'));
    notificationItems.insert(3, NotificationItem(icon: 1, title: 'gg'));
    notificationItems.insert(4, NotificationItem(icon: 1, title: 'gg'));
    context
        .read<NotificationProvider>()
        .setNotificationItemList(notificationItems);

    /////////////////////////////////////////////////////
    _refreshController.refreshCompleted();
    if (notificationItems.length > 0) {
      context.read<NotificationProvider>().setIsEmpty(false);
    }
  }

  void clearAllItems() async {
    for (int i = notificationItems.length - 1; i >= 0; i--) {
      bool isNewNotification = false;
      if (i <
          Provider.of<NotificationProvider>(context, listen: false)
              .newNotificationsCount) {
        isNewNotification = true;
      }
      listKey.currentState!.removeItem(
          i,
          (BuildContext context, Animation<double> animation) =>
              buildItem(animation, i, isNewNotification));
      await Future.delayed(Duration(milliseconds: 100));
    }
    await Future.delayed(Duration(milliseconds: 150), () {
      notificationItems.clear();
      context
          .read<NotificationProvider>()
          .setNotificationItemList(notificationItems);
      context.read<NotificationProvider>().setIsEmpty(true);
    });
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
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          return; //抵銷 ltr close drawer
        },
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
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
            child: Drawer(
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
                    : AnimatedList(
                        initialItemCount: notificationItems.length,
                        key: listKey,
                        itemBuilder: (BuildContext context, int index,
                            Animation animation) {
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
                                    .dissmisible(index, listKey);
                              },
                              key: UniqueKey(),
                              child: buildItem(
                                  animation, index, isNewNotification));
                        },
                      ),
              ),
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

  Widget buildItem(Animation animation, int index, bool isNewNotification) {
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.easeIn))
          .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ListTile(
                leading: Icon(
                  iconList[notificationItems[index].icon],
                  size: 40.0,
                ),
                title: Text(notificationItems[index].title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ESchool(),
                          maintainState: false));
                },
              ),
              Positioned(
                top: 6.0,
                left: 8.0,
                child: Icon(Icons.brightness_1,
                    color: isNewNotification ? Colors.red : Colors.transparent,
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
  }
}
