import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.black,
        dividerColor: Colors.grey,
        cardColor: Color(0xff242424),
        textTheme: TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.w300,
          ),
          title: TextStyle(
            color: Colors.white,
            fontSize: 54.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: HomeRoute(),
    );
  }
}
