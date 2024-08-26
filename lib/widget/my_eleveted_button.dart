import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';

class MyElevetedButton extends StatelessWidget {
  const MyElevetedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
  });

  final void Function() onPressed;
  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: getThemeColor(context).primaryContainer,
        foregroundColor: getThemeColor(context).onPrimaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Container(
          width: double.infinity,
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(
                    color: getThemeColor(context).onPrimaryContainer,
                  )
                : Text(title),
          )),
    );
  }
}
