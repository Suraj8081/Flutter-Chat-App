import 'package:flutter/material.dart';
import 'package:my_chat/widget/utils.dart';

class MyElevetedButton extends StatelessWidget {
  const MyElevetedButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: getThemeColor(context).primary,
        foregroundColor: getThemeColor(context).onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(title),
    );
  }
}
