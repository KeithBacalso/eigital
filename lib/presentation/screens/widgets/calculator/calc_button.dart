import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  const CalcButton({Key? key, required this.value, required this.funct})
      : super(key: key);

  final String value;
  final Function funct;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 80,
        child: Text(
          value,
        ),
      ),
      onPressed: () => value == '=' ? funct() : funct(value),
    );
  }
}
