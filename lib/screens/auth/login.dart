import 'package:bet_hint/const/constss.dart';
import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/fetch_screen.dart';
import 'package:bet_hint/screens/auth/forgot_password.dart';
import 'package:bet_hint/screens/auth/register.dart';
import 'package:bet_hint/screens/loading_manage.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/widghets/auth_button.dart';
import 'package:bet_hint/widghets/google_button.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passWordController = TextEditingController();
  final _passWordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  GlobalMethods globalMethods = GlobalMethods();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passWordController.dispose();
    _passWordFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submitFormOnLogin() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passWordController.text.trim(),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FetchScreen()));
        // print('Succesfully registered');
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 8000,
              itemBuilder: (BuildContext context, int index) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Image.asset(
                    Constss.authImagesPaths[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              itemCount: Constss.authImagesPaths.length,
              autoplay: true,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      TextWidget(
                        text: 'Welcome Back',
                        color: Colors.white,
                        textSize: 30,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        text: 'Sign in to continue',
                        color: Colors.white,
                        textSize: 18,
                        isTitle: false,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passWordFocusNode),
                                controller: _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains("@")) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return 'Please enter a valid email address';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),
                              //password
                              const SizedBox(
                                height: 12,
                              ),

                              TextFormField(
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {
                                  _submitFormOnLogin();
                                },
                                controller: _passWordController,
                                focusNode: _passWordFocusNode,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return 'Please enter a valid Password';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      )),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () {
                              globalMethods.navigateTo(
                                  ctx: context,
                                  routeName: ForgotPasswordScreen.routeName);
                            },
                            child: const Text(
                              'Forgot Password ?',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AuthButton(
                        buttomText: 'Login',
                        fct: () {
                          _submitFormOnLogin();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const GoogleButton(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          TextWidget(
                              text: 'OR', color: Colors.white, textSize: 18),
                          const SizedBox(
                            width: 8,
                          ),
                          const Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AuthButton(
                        buttomText: 'Continue as a guest',
                        fct: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const FetchScreen(),
                          ));
                        },
                        primary: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          children: [
                            TextSpan(
                              text: '  Sign up',
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
