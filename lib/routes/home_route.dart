import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String calculate = "";

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

  void operate(String str) {
    if (str == "c") {
      setState(() => calculate = "");
      return;
    }
    if (calculate.length == 1 && calculate[0] == "0") calculate = "";
    if (str == "," && calculate.contains(",")) return;
    setState(() => calculate += str);
  }

  Widget _buildButton(String str) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.0),
      child: Material(
        color: _getBackground(str),
        child: InkWell(
          onTap: () => operate(str),
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
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    calculate,
                    style: Theme.of(context).textTheme.title,
                  ),
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
