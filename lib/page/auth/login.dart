import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_routes.dart';
import '../../utils/helper.dart';
import '/../components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helper().hideKeyBoard(context);
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Login"),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/Authentication-rafiki.png",
                          height: MediaQuery.of(context).size.height * 0.40,
                        ),
                      ),
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
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
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
                                          await _login();
                                        }
                                      },
                                      child: const Text('Login',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: const Text("Don't have an account?"),
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.signup);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      )
                    ],
                  ))),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      successFunction();
    } catch (e) {
      errorFunction(e);
    }
    setState(() {
      loading = false;
    });
  }

  errorFunction(e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        Helper().showToast(context, 'Invalid email or password');
      } else if (e.code == 'network-request-failed') {
        Helper().showToast(context, 'No internet connection');
      } else {
        Helper().showToast(context, 'Login failed: ${e.message}');
      }
    } else {
      Helper().showToast(context, 'Login failed: $e');
    }
  }

  successFunction() {
    Helper().showToast(context, 'Login successful');
    Navigator.of(context).popAndPushNamed(AppRoutes.home);
  }
}
