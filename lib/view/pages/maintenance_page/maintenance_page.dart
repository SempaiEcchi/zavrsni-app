import 'package:firmus/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';

class MaintenancePage extends StatelessWidget {
  final String? error;

  const MaintenancePage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kReleaseMode ? buildReleaseBody(context) : buildDebugBody(context),
    );
  }

  Center buildReleaseBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Ažurirajte aplikaciju"),
          Text("Kako biste nastavili koristiti aplikaciju, ažurirajte je."),
          TextButton(
              onPressed: () {
                Upgrader.sharedInstance.sendUserToAppStore();
              },
              child: const Text("Ažuriraj"))
        ],
      ),
    );
  }

  Center buildDebugBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Error Page"),
          Text(error ?? ""),
          TextButton(
              onPressed: () {
                GoRouter.of(context).pushReplacement(RoutePaths.splash);
              },
              child: const Text("Retry"))
        ],
      ),
    );
  }
}
