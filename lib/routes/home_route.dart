import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/calculate.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  Calculate _calculate2 = Calculate([]);

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

  Widget _buildButton(String str) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: Material(
            color: _getBackground(str),
            child: InkWell(
              onTap: () {
                Feedback.forLongPress(context);
                setState(() => _calculate2.operate(str));
              },
              child: Align(
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
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }

  Widget _buildTop() {
    return Expanded(
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
                child: AutoSizeText(
                  _calculate2.toShowString(),
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
                  Feedback.forLongPress(context);
                  setState(
                    () => _calculate2.operate("back"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            _buildTop(),
            Divider(),
            _buildBottom(),
          ],
        ),
      ),
    );
  }
}
