import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          ThemeProvider(context), // Pass context to ThemeProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: const LoginScreen(),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  final BuildContext context; // Add context property

  ThemeProvider(this.context); // Constructor to initialize context

  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  bool get isDarkModeEnabled =>
      _currentTheme == ThemeMode.dark ||
      (_currentTheme == ThemeMode.system && isDarkModeSystem);

  bool get isDarkModeSystem =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  void toggleDarkMode() {
    _currentTheme = isDarkModeEnabled
        ? ThemeMode.light
        : ThemeMode.dark; // Toggle between light and dark mode
    notifyListeners();
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: Provider.of<ThemeProvider>(context).isDarkModeEnabled,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleDarkMode();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                // Handle logout
                // Example: Navigate to the login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
