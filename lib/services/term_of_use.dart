import 'package:animations/animations.dart';
import 'package:bet_hint/services/dialogue/policy_dialogue.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By creating an account, you are agreeing to our \n\n',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                  text: 'Term & Condition',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //open dialogue of term and condition
                      showModal(
                          context: context,
                          configuration:
                              const FadeScaleTransitionConfiguration(),
                          builder: (context) {
                            return PolicyDialogue(
                                mdFileName: 'terms_and_condition.md');
                          });
                    }),
              const TextSpan(text: '  and  '),
              TextSpan(
                  text: 'privacy policy',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //open dialogue of privacy policy
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PolicyDialogue(
                                mdFileName: 'privacy_policy.md');
                          });
                    })
            ],
          ),
        ),
      ),
    );
  }
}
