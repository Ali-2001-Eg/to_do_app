import 'package:flutter/material.dart';
import 'package:to_do_app_with_changing_theme/screens/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Center(
          child: Text(
              label,
              style: TextStyle(color: Colors.white),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
