import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sklite/SVM/SVM.dart';
import 'package:sklite/utils/io.dart';
import 'main.dart';

class BluetoothPage extends StatefulWidget {
  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> with AutomaticKeepAliveClientMixin{

  static const MethodChannel methodChannel= MethodChannel('samples.flutter.io/bluetooth');

  SVC svc;
  BluetoothPageState() {
    loadModel("assets/models/svcBadminton.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
    });
  }

  @override
  // 切换Tab导航栏保持页面状态
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  // TODO: implement widget
  // ignore: must_call_super
  Widget build(BuildContext context) {
    //final action = Provider.of<ActionsInfo>(context);
    return Column(
      children: <Widget>[
        Container(height: ScreenUtil().setHeight(450),),
        // 蓝牙扫描状态指示条
        StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                backgroundColor: Colors.lightBlueAccent,
              );
            }
            else return Container(height: 6,);
          },
        ),

        // 本机蓝牙状态
        StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            if(snapshot.data.toString().substring(15) == 'on') return bluetoothOn();
            else return bluetoothOff();
          },
        ),
        
        // 调试
        //Text('本次挥拍动作为【$Actionss】'),
        Text('接收到的数据为【$Bufferss】'),
        //Text(),
      ],
    );
  }

  // 蓝牙关闭状态
  Widget bluetoothOff() {
    return Column(
      children: <Widget>[
        Text('蓝牙未开启，请尝试打开蓝牙'),
        //RaisedButton(child: Text('打开蓝牙'),onPressed: () {},),
        RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('打开蓝牙'),
          onPressed: _openBlueTooth,
        ),

      ],
    );
  }

  // 蓝牙开启状态
  Widget bluetoothOn() {
    return ScopedModelDescendant<CounterModel>(
      builder: (context, child, model) {
        return Column(
          children: <Widget>[
            Text('点击“寻找”按钮，搜寻附近的智能羽毛球拍'),
            RaisedButton(
              child: Text('寻找'),
              onPressed: () {
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
              },
            ),
            // 蓝牙扫描结果
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data.map(
                      (r) => blueScanResult(r),
                ).toList(),
              ),
            ),

            // 已连接的设备
            Text('已连接的设备'),
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                    .map((d) => ListTile(
                  title: Text(d.name),
                  subtitle: Text(d.id.toString()),
                  trailing: StreamBuilder<BluetoothDeviceState>(
                    stream: d.state,  // d 即是已连接的蓝牙设备
                    initialData: BluetoothDeviceState.disconnected,
                    builder: (c, snapshot) {
                      if (snapshot.data == BluetoothDeviceState.connected) {
                        return RaisedButton(
                            child: Text('同步'),
                            onPressed: () {
                              blueService(d, context, child, model);
                            }
                        );
                      }
                      return Text(snapshot.data.toString());
                    },
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }


  // 扫描结果
  Widget blueScanResult(resultList){

    if(resultList.device.name == 'Badminton') {
      return Column(
        children: <Widget>[
          Text('蓝牙扫描结果'),
          RaisedButton(
            child: Text('连接'),
            onPressed: () {
              resultList.device.connect();
            },
          ),
        ],
      );
    }
    else return Container();
  }

  // 获取蓝牙设备的服务值
  blueService(device, context, child, model) async{

    await device.requestMtu(180); //请求更大的MTU，默认20，Android最大512，IOS最大185
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      if('0x${service.uuid.toString().toUpperCase().substring(4, 8)}' == '0xFFE0'){
        blueCharacteristic(service, context, child, model);
      }
    });
  }

  // 获取蓝牙设备的特征值
  blueCharacteristic(service, context, child, model) async {
    var characteristics = service.characteristics;
    for(BluetoothCharacteristic c in characteristics) {
      //List<int> value = await c.read(); print(value);
      if('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == '0xFFE1'){
        setNotifyValue(c, context, child, model);
      }
    }
  }

  // 开启订阅
  setNotifyValue(characteristics, context, child, model) async{
    await characteristics.setNotifyValue(true);
    characteristics.value.listen((List<int> value) {
      var y = ascii.decode(value);  // 将蓝牙通讯接收的值转化为字符串
      switch(value[0]) {
        // !
        case 33: {
          List<String> xx = y.substring(1).split(",");
          int predictResult = svc.predict([double.parse(xx[0]),double.parse(xx[1]),double.parse(xx[2]),double.parse(xx[3]),double.parse(xx[4]),double.parse(xx[5]),]);
          print('预测结果为: $predictResult');
          switch(predictResult) {
            case 1:{
              model.one();
              //setState(() {FlatDraw += 1; Actionss = '平抽';});
            }
            break;
            case 2:{
              model.two();
              //setState(() {FlatBlock += 1; Actionss = '平挡';});
            }
            break;
            case 3:{
              model.three();
              //setState(() {PickUp += 1; Actionss = '挑球';});
            }
            break;
            case 4:{
              model.four();
              //setState(() {Chop += 1; Actionss = '搓球';});
            }
            break;
            case 5:{
              model.five();
              //setState(() {Lofty += 1; Actionss = '高远';});
            }
            break;
            case 6:{
              model.six();
              //setState(() {Smash += 1; Actionss = '杀球';});
            }
            break;
          }
        }
        break;
        // #
        case 35:{
          switch(int.parse(y.substring(1))){
            case 1:{
              model.one();
              //setState(() {FlatDraw += 1; Actionss = '平抽';});
            }
            break;
            case 2:{
              model.two();
              //setState(() {FlatBlock += 1; Actionss = '平挡';});
            }
            break;
            case 3:{
              model.three();
              //setState(() {PickUp += 1; Actionss = '挑球';});
            }
            break;
            case 4:{
              model.four();
              //setState(() {Chop += 1; Actionss = '搓球';});
            }
            break;
            case 5:{
              model.five();
              //setState(() {Lofty += 1; Actionss = '高远';});
            }
            break;
            case 6:{
              model.six();
              //setState(() {Smash += 1; Actionss = '杀球';});
            }
            break;
          }
        }
        break;
        // $
        case 36: {
          model.max(int.parse(y.substring(1)));
        }
        break;
        // %
        case 37: {
          model.rt(int.parse(y.substring(1)));
        }
        break;
        // &
        case 38: {
          model.avg(int.parse(y.substring(1)));
        }
        break;
        // @
        case 64:{
          setState(() {
            Bufferss = y.substring(1);
          });
          print(y.substring(1));
        }
        break;
        //
        default:{}
        break;
      }
    });
  }

  Future<void> _openBlueTooth()async{		//打开蓝牙
    String message;
    message=await methodChannel.invokeMethod('openBuleTooth');
  }

}

