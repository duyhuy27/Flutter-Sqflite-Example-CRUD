import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart'; // Import your DatabaseHelper class
import 'package:quan_ly_benh_nhan_sqlite/models/User.dart'; // Import your User class
import 'package:quan_ly_benh_nhan_sqlite/screens/home_screen.dart'; // Import your HomeScreen or any screen you want to navigate to after successful login
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Xử lý đăng nhập ở đây
                  String username = usernameController.text;
                  String password = passwordController.text;

                  // Kiểm tra xem username và password có hợp lệ không
                  if (username.isNotEmpty && password.isNotEmpty) {
                    User? loggedInUser = await loginUser(username, password);

                    if (loggedInUser != null) {
                      // Đăng nhập thành công, điều hướng đến màn hình sau khi đăng nhập
                      navigateToHomeScreen();
                    } else {
                      // Đăng nhập thất bại, hiển thị thông báo lỗi
                      showErrorDialog("Invalid username or password");
                    }
                  } else {
                    showErrorDialog("Please enter both username and password");
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: navigateToSignUpScreen,
                child: Text("Đăng ký tại đây"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> loginUser(String username, String password) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return await dbHelper.loginUser(username, password);
  }

  void navigateToHomeScreen() {
    // Chuyển hướng đến màn hình sau khi đăng nhập thành công
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void navigateToSignUpScreen() {
    // Chuyển hướng đến màn hình đăng ký
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void showErrorDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
