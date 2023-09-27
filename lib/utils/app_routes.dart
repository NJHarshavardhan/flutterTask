import 'package:flipkart_task/models/photos_data.dart';
import 'package:flipkart_task/page/auth/signup.dart';
import 'package:flutter/material.dart';

import '../page/auth/login.dart';
import '../page/home.dart';
import '../page/home/item_detail.dart';



class AppRoutes {

  static const String login = '/';
  static const String initialRoute = login;
  static const String signup ="/signup";
  static const String home = "/home";
  static const String itemDetail = "/item_detail";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map args = (settings.arguments ?? {}) as Map;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const Login());
      case signup:
        return MaterialPageRoute(builder: (context) => const Signup());
      case home:
        int? index = args["index"];
        return MaterialPageRoute(builder: (context) =>  Home(index:index));
      case itemDetail:
        PhotosData data = args["data"];
        return MaterialPageRoute(builder: (context) =>  ItemDetail(photosData:data));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
