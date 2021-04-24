import 'package:flutter/material.dart';

class SmallTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double fontSize;

  const SmallTextButton({
    Key? key,
    required this.text,
    required this.onPressed, this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextButton(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
