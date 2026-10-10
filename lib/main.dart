import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

// ข้อ 24: ต้องเรียก ensureInitialized() ก่อน runApp เพราะมีการใช้ฐานข้อมูล
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อ 4-5: เรียก HomeScreen แทน Scaffold เดิม, ปิดแบนเนอร์ debug, กำหนดสีหลักเป็น indigo
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}