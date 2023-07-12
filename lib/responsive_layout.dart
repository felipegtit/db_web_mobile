import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget webBody;

  ResponsiveLayout({ required this.mobileBody, required this.webBody });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (kIsWeb) {
            return webBody;
          } else {
            return mobileBody;
          }
        }
    );
  }
}
