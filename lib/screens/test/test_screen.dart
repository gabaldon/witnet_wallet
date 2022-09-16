import 'package:flutter/material.dart';
import 'package:witnet_wallet/screens/test/test_card.dart';

class TestScreen extends StatefulWidget {
  static final route = '/test';
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: TestCard(),
    );
  }

}
