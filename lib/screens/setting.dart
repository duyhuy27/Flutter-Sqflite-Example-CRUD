// import 'package:flutter/material.dart';
//
// import 'login_screen.dart';
//
// class SettingScreen extends StatefulWidget {
//   const SettingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }
//
// class _SettingScreenState extends State<SettingScreen> {
//   bool isDarkModeEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('Cài đặt'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context)
//                   .pop(); // Điều này sẽ trở về màn hình trước đó
//             },
//           )),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Dark Mode'),
//                 Switch(
//                   value: Provider.of<ThemeProvider>(context).isDarkModeEnabled,
//                   onChanged: (value) {
//                     Provider.of<ThemeProvider>(context, listen: false)
//                         .toggleDarkMode();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             InkWell(
//               onTap: () {
//                 // Xử lý khi người dùng đăng xuất
//                 // Ví dụ: Chuyển đến màn hình đăng nhập
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: const Text(
//                 'Đăng xuất',
//                 style: TextStyle(
//                   color: Colors
//                       .red, // Màu đỏ hoặc màu phù hợp với thiết kế của bạn
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
