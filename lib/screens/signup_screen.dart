import 'package:flutter/material.dart';

import '../data/DatabaseHelper.dart';
import '../models/User.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  String username = usernameController.text;
                  String password = passwordController.text;

                  if (isValidUsername(username) && isValidPassword(password)) {
                    int userId = await signUp(username, password);

                    if (userId != -1) {
                      // Đăng ký thành công, bạn có thể thực hiện các hành động khác ở đây
                      print(
                          'Đăng ký thành công - UserID: $userId, Username: $username, Password: $password');
                      navigateToLoginScreen();
                    } else {
                      showErrorDialog(
                          'Đăng ký thất bại. Tên người dùng đã tồn tại.');
                    }
                  } else {
                    showErrorDialog(
                        'Tên người dùng hoặc mật khẩu không hợp lệ.');
                  }
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  // Chuyển hướng đến màn hình đăng nhập
                  navigateToLoginScreen();
                },
                child: Text("Đăng nhập tại đây"),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidUsername(String username) {
    // Kiểm tra logic hợp lệ cho username (ví dụ: không trống)
    return username.isNotEmpty;
  }

  bool isValidPassword(String password) {
    // Kiểm tra logic hợp lệ cho password (ví dụ: có độ dài đủ)
    return password.length >= 6;
  }

  Future<int> signUp(String username, String password) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // Kiểm tra xem username đã tồn tại chưa
    User? existingUser = await dbHelper.loginUser(username, password);
    if (existingUser != null) {
      // Tên người dùng đã tồn tại, trả về -1 để báo lỗi
      return -1;
    }

    // Nếu tên người dùng chưa tồn tại, thực hiện đăng ký
    User newUser = User(username: username, password: password);
    int userId = await dbHelper.registerUser(newUser);

    return userId;
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

  void navigateToLoginScreen() {
    // Chuyển hướng đến màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
