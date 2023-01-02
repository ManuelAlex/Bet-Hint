import 'package:bet_hint/const/constss.dart';
import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/screens/loading_manage.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/auth_button.dart';
import 'package:bet_hint/widghets/back_button.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = "/ForgotPasswordScreen";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailTextController = TextEditingController();
  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _forgotPassFCT() async {
    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains('@')) {
      GlobalMethods.errorDialog(
          subtitle: 'please enter a correct email address', context: context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "A password reset link have been sent to your email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade600,
            textColor: Colors.white,
            fontSize: 16.0);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
        //print('An error occured $error');
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
        //print('An error occured $error');
      } finally {
        _isLoading = false;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getscreenSize;

    return SafeArea(
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Stack(
            children: [
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.authImagesPaths[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: Constss.authImagesPaths.length,
                autoplay: true,
              ),
              Container(
                color: Colors.black.withOpacity(0.7),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    const BackButtons(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: 'Forgot Password',
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthButton(
                        fct: () {
                          _forgotPassFCT();
                        },
                        buttomText: 'Reset Now'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
