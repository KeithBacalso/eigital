import 'package:eigital_test/presentation/screens/widgets/calculator/calc_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "";
  double result = 0;

  // Append the pressed button number
  void numPressed(String s) {
    setState(() {
      equation += s;

      if (s == 'C') {
        equation = "";
        result = 0;
      }
    });
  }

  void equate() {
    if (equation.isEmpty) {
      return;
    }

    String parsedEquation;
    parsedEquation = equation.replaceAll('×', '*');
    parsedEquation = parsedEquation.replaceAll('÷', '/');
    parsedEquation = parsedEquation.replaceAll('−', '-');

    Parser p = Parser();
    Expression exp = p.parse(parsedEquation);
    exp.simplify();
    ContextModel cm = ContextModel();

    setState(() {
      result = exp.evaluate(EvaluationType.REAL, cm);
      equation = (result.round() == result)
          ? result.toInt().toString()
          : result.toStringAsFixed(3);
    });
  }

  void remove() {
    setState(() {
      equation = equation.isEmpty
          ? equation
          : equation.substring(0, equation.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: Container()),
          SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          equation,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.backspace_outlined),
                        onPressed: remove,
                        padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      (result.round() == result)
                          ? result.toInt().toString()
                          : result.toStringAsFixed(3),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: 'C', funct: numPressed),
              CalcButton(value: '(', funct: numPressed),
              CalcButton(value: ')', funct: numPressed),
              CalcButton(value: '/', funct: numPressed)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '7', funct: numPressed),
              CalcButton(value: '8', funct: numPressed),
              CalcButton(value: '9', funct: numPressed),
              CalcButton(value: '÷', funct: numPressed)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '4', funct: numPressed),
              CalcButton(value: '5', funct: numPressed),
              CalcButton(value: '6', funct: numPressed),
              CalcButton(value: '×', funct: numPressed)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '1', funct: numPressed),
              CalcButton(value: '2', funct: numPressed),
              CalcButton(value: '3', funct: numPressed),
              CalcButton(value: '−', funct: numPressed)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '0', funct: numPressed),
              CalcButton(value: '.', funct: numPressed),
              CalcButton(value: '=', funct: equate),
              CalcButton(value: '+', funct: numPressed)
            ],
          ),
        ],
      ),
    );
  }
}
