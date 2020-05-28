import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';//屏幕适配
import 'package:provider/provider.dart';//状态管理
import 'TabChart.dart';
import 'TabBlue.dart';
//import 'PopThemes.dart';
import 'package:scoped_model/scoped_model.dart';


// 主页  （主要包含侧拉抽屉的编写）
class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> with AutomaticKeepAliveClientMixin {

  final List<Tab>_myTabs = <Tab>[
    Tab(icon: Icon(Icons.confirmation_number, ),text:'图表',),
    Tab(icon: Icon(Icons.bluetooth, ),text:'蓝牙',),
  ];

  final _tabsPage = <Widget>[
    ChartPage(),
    BluetoothPage(),
  ];

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('EXIT?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () async {
              await pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  // 切换Tab导航栏保持页面状态
  bool get wantKeepAlive => true; ///see AutomaticKeepAliveClientMixin

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2400, allowFontScaling: false); //适配尺寸 Redmi K30 5G
    super.build(context); /// see AutomaticKeepAliveClientMixin
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(

        //页面主体
        body: DefaultTabController(
          length: _myTabs.length, // This is the number of tabs.
          initialIndex: 1,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                    flexibleSpace: new FlexibleSpaceBar(
                      background: Image.asset('assets/images/appbarPic.jpg', fit: BoxFit.fill),
                    ),
                    leading: Builder(builder: (BuildContext context) {
                      return IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          });
                    }),
                    title: const Text('深蓝 · 智能羽毛球拍'),
                    centerTitle: true,
                    pinned: true,
                    floating: false,
                    snap: false,
                    primary: true,
                    expandedHeight: 230.0,
                    elevation: 10,//是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                    forceElevated: innerBoxIsScrolled,

                    /*
                    //弹出菜单栏
                    actions: <Widget>[
                      new PopupMenuButton<String>(
                        onSelected: (String value) {
                          setState(() {
                            if(value == 'pop01') Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => ThemePage()));
                          });
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          new PopupMenuItem(
                            value: 'pop01',
                            child: ListTile(
                              leading: Icon(Icons.format_paint),
                              title: new Text("主题"),
                            ),
                          ),
                          new PopupMenuDivider(height: 1.0),
                        ],
                        //tooltip: '', //长按按钮提示文字。
                      )
                    ],
                     */

                    bottom: TabBar(
                      //unselectedLabelColor: Colors.grey,//设置未选中时的字体颜色，tabs里面的字体样式优先级最高
                      unselectedLabelStyle: TextStyle(fontSize: 16),//设置未选中时的字体样式，tabs里面的字体样式优先级最高
                      //labelColor: Colors.black,//设置选中时的字体颜色，tabs里面的字体样式优先级最高
                      labelStyle: TextStyle(fontSize: 24.0),//设置选中时的字体样式，tabs里面的字体样式优先级最高
                      isScrollable: true,//允许左右滚动
                      indicatorColor: Colors.greenAccent,//选中下划线的颜色
                      indicatorSize: TabBarIndicatorSize.tab,//选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
                      indicatorWeight: 3.0,//选中下划线的高度，值越大高度越高，默认为2
                      tabs: _myTabs,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: _tabsPage,
            ),
          ),
        ),
        //侧拉抽屉
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text('用户'),
                accountEmail: new Text('757122943@qq.com'),
                currentAccountPicture: new GestureDetector(
                  //onTap: () => print('当前使用者'),  //手势检测器
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage('http://bpic.588ku.com/element_origin_min_pic/16/09/22/1657e3976d8e57a.jpg'),),
                ),
              ),
              new ListTile(
                  title: new Text('关于本App'),
                  trailing: new Icon(Icons.announcement),
                  onTap: () {
                    Navigator.of(context).pop();  //收回侧抽屉
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AboutDialog(
                          applicationName: '深蓝智能羽毛球拍',
                          //applicationIcon: Image.network('http://img.mp.sohu.com/q_mini,c_zoom,w_640/upload/20170724/9b7eef81186141189c76aecd267d0462.jpg'),  //应用图标
                          applicationVersion: '1.2',
                          applicationLegalese:'com.example.skyy',//应用许可证
                          children: <Widget>[
                            //new Text('APP ID'),
                          ],
                        );

                      },
                    );
                  }
              ),
              new Divider(),
              Column(
                children: <Widget>[
                  Consumer<ThemeState>(
                    builder: (_, state, __) => IconButton(
                      icon: Icon(Icons.brightness_1),
                      onPressed: () {
                        state.changeThemeData(ThemeData(brightness: Brightness.light));
                      },
                    ),
                  ),





                  Consumer<ThemeState>(
                    builder: (_, state, __) => IconButton(
                      icon: Icon(Icons.brightness_3),
                      onPressed: () {
                        state.changeThemeData(ThemeData(brightness: Brightness.dark));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

