/**
 * 广告页，3秒自动跳转到首页
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer; // 定时器
  int count = 2;  // 倒计时（3秒）
  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      // 空等1秒之后再计时
      _timer = new Timer.periodic(const Duration(milliseconds: 1000), (v) {
        count--;
        if (count == 0) {
          navigationPage();
        } else {
          setState(() {});
        }
      });
      return _timer;
    });
  }

  void navigationPage() {
    _timer.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: const Alignment(1.0, -1.0), // 右上角对齐
      children: [
        new ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Image.asset("assets/images/ad.jpg",fit: BoxFit.fill,),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
          child: new FlatButton(
            onPressed: () {navigationPage();},
            color: Colors.grey,
            child: new Text(
              "$count 跳过广告",
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),),
        )
      ],
    );
  }
}