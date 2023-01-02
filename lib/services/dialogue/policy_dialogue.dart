import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialogue extends StatelessWidget {
  final double radius;
  final String mdFileName;
  PolicyDialogue({Key? key, this.radius = 8, required this.mdFileName})
      : assert(
            mdFileName.contains('.md'), 'The file must contain .md extension'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 150))
                      .then((value) {
                    return rootBundle
                        .loadString('lib/screens/assets/$mdFileName');
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Markdown(data: snapshot.data.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("close"),
              style: const ButtonStyle(),
            ),
          )
        ],
      ),
    );
  }
}
