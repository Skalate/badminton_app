import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'main.dart';



class ThemePage extends StatefulWidget {
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主题色切换'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Consumer<ThemeState>(
                builder: (_, state, __) => IconButton(
                  icon: Icon(Icons.color_lens),
                  color: Colors.blue,
                  onPressed: () {
                    state.changeThemeData(ThemeData(primaryColor: Colors.blue));
                  },
                ),
              ),
              Consumer<ThemeState>(
                builder: (_, state, __) => IconButton(
                  icon: Icon(Icons.color_lens),
                  color: Colors.green,
                  onPressed: () {
                    state
                        .changeThemeData(ThemeData(primaryColor: Colors.green));
                  },
                ),
              ),
              Consumer<ThemeState>(
                builder: (_, state, __) => IconButton(
                  icon: Icon(Icons.color_lens),
                  color: Colors.red,
                  onPressed: () {
                    state.changeThemeData(ThemeData(primaryColor: Colors.red));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }
}