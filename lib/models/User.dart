class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0, // Đặt giá trị mặc định là 0 nếu 'id' không tồn tại
      username: map['username'],
      password: map['password'],
    );
  }
}
