import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/app_theme.dart';
import 'package:moneygo/ui/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(username: 'markpausanos'),
      theme: appTheme,
    );
  }
}
