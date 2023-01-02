import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BackButtons extends StatelessWidget {
  const BackButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
      child: const Icon(
        IconlyLight.arrowLeft2,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
