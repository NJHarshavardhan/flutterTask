import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_task/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/loader.dart';
import '../../utils/helper.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: (){
       Helper().hideKeyBoard(context);
     },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Signup"),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Column(
                    children: [
                      Image.asset("assets/images/Authentication-rafiki.png"),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 9,
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                if (value.length < 8) {
                                  return 'Must be more than 8 characters';
                                }
                                return null;
                              },
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                    icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    }),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              child: loading
                                  ? SizedBox(
                                      height: 50.h,
                                      child: Loader(loading: loading),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        Helper().hideKeyBoard(context);
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          await _signUp();
                                        }
                                      },
                                      child: const Text('Signup',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await userCredential.user!.updateDisplayName(nameController.text);
      await userCredential.user!.reload();
      successFunction();
    } catch (e) {
      errorFunction(e);
    }
    setState(() {
      loading = false;
    });
  }

  successFunction() {
    Helper().showToast(context, 'Registered successfully.');
    Navigator.of(context).popAndPushNamed(AppRoutes.home);
  }
  errorFunction(e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'email-already-in-use') {
        Helper().showToast(
            context, 'Email is already in use. Please use another email.');
      } else if (e.code == 'network-request-failed') {
        Helper().showToast(context, 'No internet connection');
      }
    } else {
      Helper().showToast(context, 'Sign-up failed: $e');
    }
  }
}
