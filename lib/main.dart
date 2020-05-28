// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import 'package:flutter/material.dart';
// 下面两个包是用于实现沉浸式状态栏的
import 'dart:io';
import 'package:flutter/services.dart';
// 状态管理，显示主题用
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
// 获取版本号来判断显示引导页还是广告页
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
// 引导页、广告页  二选一
import 'IntroScreen.dart';
import 'AdverScreen.dart';
// --------------------------------------------------------------

String Bufferss = '暂无通讯数据';
String Actionss = '暂无动作数据';

int MAXSpeed = 0;
int AVGSpeed = 0;
int RTSpeed = 0;


void main() {
  runApp(Wrapper(child: MyApp(model: CounterModel(),)));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

// 包裹，实现provider用的
class Wrapper extends StatelessWidget {
  Wrapper({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final initThemeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
    ); //初始主题数据

    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeState(initThemeData),
        )          // 标准的provider构建法，用于构建新的value
      ],
      child: child,
    );
  }
}

// MyApp
class MyApp extends StatelessWidget {

  final CounterModel model;
  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CounterModel>(
      model: model,

      child: Consumer<ThemeState>(
        builder: (_, state, __) => MaterialApp(
          theme: state.themeData, // 如果没有闪屏的话，直接接home: MyHomePage(),
          debugShowCheckedModeBanner: false,
          home: Enter(),

        ),
      ),



    );
  }
}


//---->[入口控制页面]----
class Enter extends StatefulWidget {
  @override
  EnterState createState() {
    // TODO: implement createState
    return EnterState();
  }
}

class EnterState extends State<Enter> {
  Widget homePage = new Container();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //获取显示的页面
    IsIntroOrAdvertise();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return homePage;
  }

  // ignore: non_constant_identifier_names
  IsIntroOrAdvertise() async {
    String currentVersion = await getVersion();
    String storageVersion = await getOldVersion();
    setState(() {
      if (storageVersion == currentVersion) {
        homePage = SplashScreen(); //版本号相同显示首页
      } else {
        homePage = IntroScreen(); //版本号不一致， 显示引导页
        setNewVersion(); //本地存储新的版本号
      }
    });
  }

  //获取当前版本号
  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    //String buildNumber = packageInfo.buildNumber;
    return version;
  }

  //获取旧版本号
  Future<String> getOldVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String version = sharedPreferences.getString('OLD_VERSION') ?? "";
    return version;
  }

  //设置新的版本号
  setNewVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    sharedPreferences.setString("OLD_VERSION", version);
  }
}


//---->[provider/theme_state.dart]----
class ThemeState extends ChangeNotifier {
  ThemeData _themeData; //主题
  ThemeState(this._themeData,);
  // 修改主题
  void changeThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
  ThemeData get themeData => _themeData; //获取主题
}



class CounterModel extends Model {

  int _flatDraw = 0;//平抽
  int get flatDraw => _flatDraw;
  int _flatBlock = 0;//平挡
  int get flatBlock => _flatBlock;
  int _pickUp = 0;//挑球
  int get pickUp => _pickUp;
  int _chop = 0; //搓球
  int get chop => _chop;
  int _lofty = 0;//高远
  int get lofty => _lofty;
  int _smash = 0;//杀球
  int get smash => _smash;

  void one() {
    _flatDraw++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }
  void two() {
    _flatBlock++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }
  void three() {
    _pickUp++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }
  void four() {
    _chop++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }
  void five() {
    _lofty++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }
  void six() {
    _smash++;// First, increment the counter
    notifyListeners();// Then notify all the listeners.
  }


  int _maxSpeed = 0;
  int get maxSpeed => _maxSpeed;
  void max(int value) {
    _maxSpeed = value;    // First, increment the counter
    notifyListeners();    // Then notify all the listeners.
  }
  int _avgSpeed = 0;
  int get avgSpeed => _avgSpeed;
  void avg(int value) {
    _avgSpeed = value;    // First, increment the counter
    notifyListeners();    // Then notify all the listeners.
  }
  int _rtSpeed = 0;
  int get rtSpeed => _rtSpeed;
  void rt(int value) {
    _rtSpeed = value;    // First, increment the counter
    notifyListeners();    // Then notify all the listeners.
  }

}