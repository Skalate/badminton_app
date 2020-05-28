# skyy

深蓝（skyy）智能羽毛球拍前端APP

## 开始使用

**官方建议**  
This project is a starting point for a Flutter application.  
A few resources to get you started if this is your first Flutter project:  
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)  
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)  

For help getting started with Flutter, view our [online documentation](https://flutter.dev/docs),   
which offers tutorials, samples, guidance on mobile development, and a full API reference.  

**个人笔记**  
https://github.com/Skalate/notes/flutter.md  
除flutter笔记外，还有单片机等其他技术的笔记，个人整理，长期更新，如有错误，敬请斧正。


## 开发环境
CORE: flutter 1.12.13+hotfix.7  
JAVA: jkd 1.8.0_181  
IDE:  Android Studio 3.6.3  

## 工程结构
**工程文件结构**  
文件夹 | 作用
 - | - 
android | android平台相关代码
ios | ios平台相关代码
lib | flutter相关代码,主函数
test | 存放测试代码
pubspec.yaml | 配置文件，存放第三方库的依赖
assets | 存放本地数据，内含"images"和"jsons"等文件夹


**lib建议文件结构**  
文件 | 作用
 - | - 
common | 工具类，如通用方法类、网络接口类、保存全局变量的静态类等
i10n | 国际化相关代码
models | 通过json to models生成的model类文件
routes | 存放项目的所有页面代码
states | 保存app中需要跨组件共享的状态类
widgets | 存放自定义Widget


