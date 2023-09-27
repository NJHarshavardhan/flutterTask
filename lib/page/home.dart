import 'dart:io';

import '/../config/constant.dart';
import 'package:flutter/material.dart';

import 'account.dart';
import 'cart.dart';
import 'categories.dart';
import 'home/explore.dart';
import 'notifications.dart';

class Home extends StatefulWidget {
  final int? index;

  const Home({Key? key, this.index}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[
    const Explore(),
    const CategoriesScreen(),
    const Notifications(),
    const Account(),
    const Cart(),
  ];

  @override
  void initState() {
    if (widget.index != null) {
      _selectedIndex = widget.index!;
    }
    super.initState();
  }

  Future _onWillPop() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(appTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            content: Text('Are you sure want to close app?',
                style: Theme.of(context).textTheme.bodyMedium),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              MaterialButton(
                onPressed: () => exit(0),
                color: Theme.of(context).colorScheme.primary,
                child: Text('Yes',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
    return true;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: pages.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black54,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
          ),
        ),
        onWillPop: () async => await _onWillPop());
  }
}
