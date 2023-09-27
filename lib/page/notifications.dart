import 'package:flutter/material.dart';
class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Center(
        child: Image.asset("assets/images/error.png"),
      )),
    );
  }
}
