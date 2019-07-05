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
      if (str == "+/-" || str == "." || str == "=") return Colors.white;
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

  int _numOf(String str, String search) {
    int sum = 0;
    for (int i = 0; i < str.length; i++) if (str[i] == search) sum++;
    return sum;
  }

  String _lastChar(String str) {
    return str[str.length - 1];
  }

  bool _lastCharIs(String str, List<String> chars) {
    if (str.length == 0) return false;
    for (String char in chars) if (str[str.length - 1] == char) return true;
    return false;
  }

  List<String> _toCharList(String str) {
    List<String> result = [];
    for (int i = 0; i < str.length; i++) result.add(str[i]);
    return result;
  }

  String _toString(List<String> chars) {
    String result = "";
    for (String char in chars) result += char;
    return result;
  }

  void _operate(String str) {
    if (_calculate == "error") setState(() => _calculate = "");

    if (str == "=") {
      if (_numOf(_calculate, "(") != _numOf(_calculate, ")") ||
          _lastCharIs(_calculate, ["+", "-", "x", "/"])) {
        return;
      }
      try {
        setState(() => _calculate = _toString(
              _solve(_toCharList(_calculate)),
            ));
      } catch (_) {
        setState(() => _calculate = "error");
      }
      return;
    }

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

    if (str == "." && _calculate.contains(".")) return;
    if (str == "." && _calculate.length == 0) {
      setState(() => _calculate += "0.");
      return;
    }

    if ((str == "/" || str == "x" || str == "-" || str == "+") &&
        _lastCharIs(_calculate, ["(", "/", "x", "-", "+"])) return;

    if ((str == "%" && _lastCharIs(_calculate, ["%", "(", "/", "x", "-", "+"])))
      return;

    if (_calculate == "0") _calculate = "";
    setState(() => _calculate += str);
  }

  List<String> _solve(List<String> string) {
    List<String> str = List.from(string);
    try {
      double.parse(_toString(str));
      return str;
    } catch (_) {}
    if (str.length == 1) return [double.parse(str[0]).toString()];

    if (str.contains("(") && str.contains(")")) {
      final closeIndex = str.indexOf(")");
      final openIndex = str.sublist(0, closeIndex).lastIndexOf("(");
      str.replaceRange(
        openIndex,
        closeIndex + 1,
        _solve(str.sublist(openIndex + 1, closeIndex)),
      );
      return _solve(str);
    }

    if (str.contains("-") || str.contains("+")) {
      if (str[0] == "+" || str[0] == "-") str.insert(0, "0");
      List<List<String>> terms = [];
      int lastIndex = 0;
      for (int i = 0; i < str.length; i++) {
        if (str[i] == "+" || str[i] == "-") {
          terms.add(str.sublist(lastIndex, i));
          terms.add([str[i]]);
          lastIndex = i + 1;
        }
      }
      terms.add(str.sublist(lastIndex));
      double sum = double.parse(_toString(_solve(terms[0])));
      for (int i = 2; i < terms.length; i += 2) {
        final double term = double.parse(_toString(_solve(terms[i])));
        sum += terms[i - 1][0] == "+" ? term : -term;
      }
      return _toCharList(sum.toString());
    }
    if (str.contains("/") || str.contains("x")) {
      int index;
      bool mult;
      if (str.contains("/")) {
        index = str.indexOf("/");
        mult = false;
      } else {
        index = str.indexOf("x");
        mult = true;
      }
      final double term1 = double.parse(_toString(
        _solve(
          str.sublist(0, index),
        ),
      ));
      final double term2 = double.parse(_toString(
        _solve(
          str.sublist(index + 1),
        ),
      ));
      if (term2 == 0 && !mult) return null;
      return mult
          ? _toCharList((term1 * term2).toString())
          : _toCharList((term1 / term2).toString());
    }
    if (str.contains("%")) {
      return _toCharList(
        (double.parse(_toString(str.sublist(0, str.length - 1))) / 100)
            .toString(),
      );
    }
    return null;
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
                      _buildButton("."),
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
