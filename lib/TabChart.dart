import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';
class ChartPage extends StatefulWidget {

  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;// 切换Tab导航栏保持页面状态

  @override
  // TODO: implement widget
  // ignore: must_call_super
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: ScreenUtil().setHeight(450),),

          /*
          Container(height: ScreenUtil().setHeight(100),),
          Text('挑高球：100',style: TextStyle(fontSize: 20),),
          Text('杀球：98',style: TextStyle(fontSize: 20),),
          Text('搓球：91',style: TextStyle(fontSize: 20),),

           */

          Container(height: ScreenUtil().setHeight(100),),

          ScopedModelDescendant<CounterModel>(
            builder: (context, child, model) {
              return Container(
                child: Echarts(
                  option: '''
                {
                  backgroundColor: '#FAFAFA',
                  title: {
                    text: '挥拍动作统计',
                    //subtext: '纯属虚构',
                    left: 'center'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)'
                },
                legend: {
                    left: 'center',
                    top: 'bottom',
                    data: ['挑球', '高远', '杀球', '平抽', '平挡', '搓球',]
                },
                toolbox: {
                    show: true,
                    feature: {
                        mark: {show: true},
                        dataView: {show: true, readOnly: false},
                        magicType: {
                            show: true,
                            type: ['pie', 'funnel']
                        },
                        restore: {show: true},
                    }
                },
                series: [
                    {
                        name: '累计击球数',
                        type: 'pie',
                        radius: [20, 80],
                        center: ['50%', '50%'],
                        avoidLabelOverlap: false,
                        //startAngle: 0,
                        roseType: 'area',
                        selectedMode: "single",
                        data: [
                            {value: ${model.pickUp}, name: '挑球'},
                            {value: ${model.lofty}, name: '高远'},
                            {value: ${model.smash}, name: '杀球'},
                            {value: ${model.flatDraw}, name: '平抽'},
                            {value: ${model.flatBlock}, name: '平挡'},
                            {value: ${model.chop}, name: '搓球'},
                        ]
                    }
                ]
                }
              ''',
                ),
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setHeight(800),
              );
            },
          ),
          Container(height: ScreenUtil().setHeight(100),),
          // 仪表盘
          ScopedModelDescendant<CounterModel>(
            builder: (context, child, model) {
              return Container(
                child: Echarts(
                  option: '''
{
    backgroundColor: '#FAFAFA',
    tooltip: {},
    toolbox: {
        show: true
    },
    title: {
      left: 'center',
      text: '羽毛球球速  km/h'
    },
   
    series: [{
        name: '实时球速',
        type: 'gauge',
        z: 3,
        min: 0,
        max: 400,
        splitNumber: splitNumber[0],
        radius: '60%',
        axisLine: {
            lineStyle: {
                width: 3
            }
        },
        axisTick: {
            length: 1,
            lineStyle: {
                color: 'auto'
            }
        },
        splitLine: {
            length: 10,
            lineStyle: {
                color: 'auto'
            }
        },
        axisLabel: {},
        title: {
            fontWeight: 'bolder',
            fontSize: 15,
            offsetCenter: [0, '80%']
        },
        pointer: {
            width: 3
        },
        detail: {
            fontSize: 25,
            offsetCenter: [0, '50%']
        },
        data: [{
            value: ${model.rtSpeed},
            name: '实时球速'
        }]
    }, {
        name: '最高球速',
        type: 'gauge',
        center: ['20%', '55%'],
        radius: '45%',
        min: min[1],
        max: 400,
        endAngle: 45,
        splitNumber: splitNumber[1],
        axisLine: {
            lineStyle: {
                width: 2
            }
        },
        axisTick: {
            length: 1,
            lineStyle: {
                color: 'auto'
            }
        },
        splitLine: {
            length: 8,
            lineStyle: {
                color: 'auto'
            }
        },
        pointer: {
            width: 2
        },
        title: {
            fontSize: 15,
            offsetCenter: [0, '80%']
        },
        detail: {
            fontSize: 20,
            offsetCenter: [0, '50%']
        },
        data: [{
            value: ${model.maxSpeed},
            name: '最高球速',

        }]
    },  {
        name: '平均球速',
        type: 'gauge',
        center: ['80%', '55%'],
        radius: '45%',
        min: 0,
        max: 400,
        startAngle: 135,
        endAngle: -45,
        splitNumber: splitNumber[2],
        axisLine: {
            lineStyle: {
                width: 2
            }
        },
        axisTick: {
            splitNumber: 1,
            length: 2,
            lineStyle: {
                color: 'auto'
            }
        },
        axisLabel: {},
        splitLine: {
            length: 8,
            lineStyle: {
                color: 'auto'
            }
        },
        pointer: {
            width: 2
        },
        title: {
            fontSize: 15,
            offsetCenter: [0, '80%']
        },
        detail: {
            fontSize: 20,
            offsetCenter: [0, '50%']
        },
        data: [{
            value: ${model.avgSpeed},
            name: '平均球速',
        }]    
    }]
}
                ''',
                  extraScript: '''
                var min = [0, 0, 0];
                var max = [100, 150, 300];
                var splitNumber = [10, 5, 5] ;
                ''',
                ),
                height: ScreenUtil().setHeight(800),
                width: ScreenUtil().setWidth(1080),
              );
            },
          ),


          // 雷达图
          /*
            Container(
              child: Echarts(
                option: '''
              {
                backgroundColor: '#fff',
                title: {
                    left: 'center',
                    text: '羽毛球竞技风格'
                },
                tooltip: {},
                //legend: {data: ['风格']},
                radar: {
                    shape: 'circle',
                    name: {
                        textStyle: {
                            color: '#fff',
                            backgroundColor: '#999',
                            borderRadius: 2,
                            padding: [3, 5]
                        }
                    },
                    radius: 100,
                    indicator: [
                        { name: '前场', max: 6500},
                        { name: '进攻', max: 16000},
                        { name: '积极进攻', max: 30000},
                        { name: '控场', max: 38000},
                        { name: '积极防守', max: 52000},
                        { name: '防守', max: 25000}
                    ]
                },
                series: [{
                    name: '预算 vs 开销（Budget vs spending）',
                    type: 'radar',
                    // areaStyle: {normal: {}},
                    data: [
                        {
                            value: [4300, 10000, 28000, 35000, 50000, 19000],
                            name: '风格'
                        },
                    ]
                }]
            }

            ''',
              ),
              height: 340,
              width: 400,
            ),
             */

        ],
      ),
    );
  }
}

