import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class Helper {
  static final Helper _helper = Helper._internal();
  BuildContext? ctx;

  factory Helper() {
    return _helper;
  }

  Helper._internal();

  setContext(BuildContext context) {
    ctx = context;
  }

  BuildContext getContext() {
    return ctx!;
  }

  void hideKeyBoard(BuildContext context) {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      Helper().printMessage(e);
    }
  }

  void printMessage(message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  void showToast(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 100,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r))),
      margin: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      content: Text(message),
    ));
  }
}
