import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/notification_handler.dart';
import 'package:firmus/infra/stores/notification_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.refresh(notificationListController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationListController);
    if (notifications is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (notifications is AsyncError) {
      logger.info(notifications.stackTrace);

      return Center(child: Text("Error ${notifications.error}"));
    }
    if (notifications.requireValue.isEmpty) {
      return Center(
          child: Text(
        "Nemate obavijesti",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.grey),
      ));
    }

    return ListView.builder(
        itemCount: notifications.requireValue.length,
        itemBuilder: (context, index) {
          final noti = notifications.requireValue[index];
          return ListTile(
            onTap: (){
              ref.read(notificationHandlerProvider.notifier).handleTap(noti);
            },
            leading: Icon(Icons.notifications_outlined),
            title: Text(noti.title),
            subtitle: Text(noti.body ?? ''),
          );
        });
  }
}
