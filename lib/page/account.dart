import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_routes.dart';
import '/../config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Account"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: _logout(),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildProfile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      decoration: customBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user!.displayName == null ? Container() : const Text("Name"),
          user!.displayName == null ? Container() : _title(user!.displayName ?? ""),
          const Text("Email"),
          _title(user!.email!),
        ],
      ),
    );
  }

  Widget _logout() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: customBoxDecoration(),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(appTitle,
                    style: Theme.of(context).textTheme.headlineSmall),
                content: Text('Are you sure want to logout?',
                    style: Theme.of(context).textTheme.bodyMedium),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'No',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.popUntil(
                            context, ModalRoute.withName(AppRoutes.login));
                        Navigator.of(context).pushNamed(AppRoutes.login);
                      } catch (e) {
                        print(' $e');
                      }
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: ListTile(
          dense: true,
          title: Text(
            'Logout',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600),
          ),
          leading: SizedBox(
            width: 50.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  height: 20.h,
                  child: const VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                )
              ],
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  BoxDecoration customBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.grey),
      ],
    );
  }

  _title(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
