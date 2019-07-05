import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String _calculate = "";

  Color _getColor(String str) {
    if (str == "c") return Colors.deepOrange[400];
    try {
      int.parse(str);
      return Colors.white;
    } on FormatException {
      if (str == "+/-" || str == "," || str == "=") return Colors.white;
      return Colors.green[400];
    }
  }

  Color _getBackground(String str) {
    if (str == "=") return Color(0xff00ae55);
    return Theme.of(context).cardColor;
  }

  bool _isNumber(String str) {
    if (str.length != 1) return false;
    try {
      int.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }

/*

  String _solve(String exp) {
    if (exp.isEmpty) return "";

    List<String> stringTerms = [];
    int prevIndex = 0;
    for (int i = 0; i < exp.length; i++) {
      if (exp[i] == "+" || exp[i] == "-") {
        stringTerms.add(exp.substring(prevIndex, i));
        prevIndex = i;
      }
    }
    stringTerms.add(exp.substring(prevIndex));
    if (stringTerms[0].isEmpty) stringTerms.removeAt(0);
    if (stringTerms[0][0] != "-") stringTerms[0] = "+${stringTerms[0]}";

    List<double> terms = [];
    for (String str in stringTerms) {
      double parsed = _parse(str);
      if (parsed == null) return "error";
      terms.add(parsed);
    }
    double sum = 0;
    for (double term in terms) sum += term;

    String result = sum.toString();
    if (result.substring(result.length - 2) == ".0")
      result = "${result.substring(0, result.length - 2)}";
    return result;
  }

  double _parse(String str) {
    if (!str.contains("x") && !str.contains("/")) return double.parse(str);
    if (!str.contains("/")) {
      List<String> stringFactors = str.split("x");
      double product = 1;
      for (String stringFactor in stringFactors) {
        product *= double.parse(stringFactor);
      }
      return product;
    }
    List<String> temp = str.split("/");
    String stringDenomerator = "";
    for (String str in temp.sublist(1)) stringDenomerator += "/$str";
    stringDenomerator = stringDenomerator.substring(1);
    if (stringDenomerator.isEmpty) stringDenomerator = "1";

    double numerator = _parse(temp[0]);
    double denomerator = _parse(stringDenomerator);
    if (numerator == null) return null;
    if (denomerator == null) return null;
    if (denomerator == 0) return null;
    return numerator / denomerator;
  }

    */

  String _solve(String str) {
    return "error";
  }

  int _numOf(String str, String search) {
    int sum = 0;
    for (int i = 0; i < str.length; i++) if (str[i] == search) sum++;
    return sum;
  }

  String _lastChar(String str) {
    return str[str.length - 1];
  }

  bool _lastCharIs(String str, List<String> chars) {
    for (String char in chars) if (str[str.length - 1] == char) return true;
    return false;
  }

  void _operate(String str) {
    if (str == "=") {
      setState(() => _calculate = _solve(_calculate));
      return;
    }
    if (_calculate == "error") setState(() => _calculate = "");
    if (str == "()") {
      setState(() {
        if (_calculate.length == 0 || _lastChar(_calculate) == "(") {
          _calculate += "(";
        } else if (_numOf(_calculate, "(") > _numOf(_calculate, ")")) {
          if (_lastCharIs(_calculate, ["/", "x", "+", "-"])) return;
          _calculate += ")";
        } else if (_lastCharIs(_calculate, ["/", "x", "+", "-"])) {
          _calculate += "(";
        } else {
          _calculate += "x(";
        }
      });
      return;
    }
    if (str == "c") {
      setState(() => _calculate = "");
      return;
    }
    if (str == "back") {
      if (_calculate.length == 0) return;
      setState(
          () => _calculate = _calculate.substring(0, _calculate.length - 1));
      return;
    }
    if (str == "+/-") {
      if (_calculate.length == 0 || _calculate[0] != "-")
        setState(() => _calculate = "-$_calculate");
      else
        setState(() => _calculate = _calculate.substring(1));
      return;
    }
    if (str == "," && _calculate.contains(",")) return;
    if (str == "," && _calculate.length == 0) {
      setState(() => _calculate += "0,");
      return;
    }
    if ((str == "/" || str == "x" || str == "-" || str == "+") &&
        _lastCharIs(_calculate, ["(", "/", "x", "-", "+"])) return;
    if (str == "%" && _lastCharIs(_calculate, ["%", "(", "/", "x", "-", "+"]))
      return;

    if (_calculate.length == 1 && _calculate[0] == "0") _calculate = "";
    setState(() => _calculate += str);
  }

  Widget _buildButton(String str) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.0),
      child: Material(
        color: _getBackground(str),
        child: InkWell(
          onTap: () => _operate(str),
          child: Container(
            width: 72.0,
            height: 52.0,
            alignment: Alignment.center,
            child: Text(
              str,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: _getColor(str)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 14.0,
                  top: 52.0,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          _calculate,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.backspace,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _operate("back");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildRow([
                      _buildButton("c"),
                      _buildButton("()"),
                      _buildButton("%"),
                      _buildButton("/"),
                    ]),
                    _buildRow([
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
                      _buildButton("x"),
                    ]),
                    _buildRow([
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                      _buildButton("-"),
                    ]),
                    _buildRow([
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                      _buildButton("+"),
                    ]),
                    _buildRow([
                      _buildButton("+/-"),
                      _buildButton("0"),
                      _buildButton(","),
                      _buildButton("="),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
