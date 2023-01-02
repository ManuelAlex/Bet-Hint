import 'package:bet_hint/const/constss.dart';
import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/fetch_screen.dart';
import 'package:bet_hint/screens/auth/login.dart';
import 'package:bet_hint/screens/loading_manage.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/term_of_use.dart';
import 'package:bet_hint/widghets/auth_button.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passWordController = TextEditingController();
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  final _passWordFocusNode = FocusNode();
  var _obscureText = true;
  GlobalMethods globalMethods = GlobalMethods();
  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passWordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _userNameFocusNode.dispose();

    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submitFormOnRegister() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passWordController.text.trim());

        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        bool _sub = false;

        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'userName': _userNameController.text,
          'fullName': _fullNameController.text,
          'email': _emailTextController.text,
          'bookings': [],
          'subscription': _sub,
          'createdAt': Timestamp.now(),
        });
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
        _isLoading = false;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Stack(
            children: [
              Swiper(
                duration: 800,
                autoplayDelay: 8000,
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      TextWidget(
                        text: 'Welcome',
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
                                    .requestFocus(_fullNameFocusNode),
                                controller: _userNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return 'Please enter a username ';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),

                              ///full name
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                                controller: _fullNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return 'Please enter your full name';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Full name',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),

                              //email
                              const SizedBox(
                                height: 12,
                              ),
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
                                  _submitFormOnRegister();
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
                                    return 'Please enter a valid Password ';
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
                            onPressed: () {},
                            child: const Text(
                              '',
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
                        buttomText: 'Sign up',
                        fct: () {
                          _submitFormOnRegister();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already a user ?',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          children: [
                            TextSpan(
                                text: '   Log in ',
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
                                                const LoginScreen()));
                                  }),
                          ],
                        ),
                      ),
                      // Terms and condition
                      const SizedBox(
                        height: 15,
                      ),
                      const TermsOfUse(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
