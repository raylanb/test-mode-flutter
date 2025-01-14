import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/timer_screen.dart';
import 'providers/timer_provider.dart';
import 'providers/theme_provider.dart';
import 'package:flutter/services.dart';

void main() {

  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 顶部状态栏背景色
    statusBarIconBrightness: Brightness.light, // 顶部状态栏图标亮度
    systemNavigationBarColor: Colors.transparent, // 导航栏背景色
    systemNavigationBarIconBrightness: Brightness.light, // 导航栏图标亮度
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // 根据主题设置状态栏和导航栏样式
        SystemChrome.setSystemUIOverlayStyle(
          themeProvider.isDark
              ? SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.grey[800], // 深色主题状态栏颜色
                  statusBarIconBrightness: Brightness.light, // 深色主题状态栏图标
                  systemNavigationBarColor: Colors.grey[800],
                  systemNavigationBarIconBrightness: Brightness.light,
                )
              : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Colors.white, // 浅色主题状态栏颜色
                  statusBarIconBrightness: Brightness.dark, // 浅色主题状态栏图标
                  systemNavigationBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
        );

        return MaterialApp(
          title: '工作休息平衡计时器',
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[800],
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
            ),
          ),
          themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const TimerScreen(),
        );
      },
    );
  }
}