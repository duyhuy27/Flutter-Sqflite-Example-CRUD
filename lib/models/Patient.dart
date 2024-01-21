class Patient {
  int id;
  String name;
  int age;
  String gender;
  String address;

  Patient(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'address': address,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
        id: map['id'],
        name: map['name'],
        age: map['age'],
        gender: map['gender'],
        address: map['address']);
  }
}
