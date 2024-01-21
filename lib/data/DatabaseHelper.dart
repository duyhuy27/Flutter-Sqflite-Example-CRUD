import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/MedicalRecord.dart';
import '../models/Patient.dart';
import '../models/User.dart';

class DatabaseHelper {
  static Database? _database; // Change: Make _database nullable
  static const String dbName = 'patients.db';
  static const String patientTable = 'patients';
  static const String medicalRecordTable = 'medical_records';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $patientTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $medicalRecordTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        diagnosis TEXT,
        patientId INTEGER,
        FOREIGN KEY (patientId) REFERENCES $patientTable(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      password TEXT
    )
  ''');
  }

  Future<int> insertPatient(Patient patient) async {
    Database db = await instance.database;
    return await db.insert(patientTable, patient.toMap());
  }

  Future<List<Patient>> getAllPatients() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(patientTable);
    return List.generate(maps.length, (i) {
      return Patient.fromMap(maps[i]);
    });
  }

  Future<int> updatePatient(Patient patient) async {
    Database db = await instance.database;
    return await db.update(
      patientTable,
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> deletePatient(int id) async {
    Database db = await instance.database;
    return await db.delete(
      patientTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertMedicalRecord(MedicalRecord record) async {
    Database db = await instance.database;
    return await db.insert(medicalRecordTable, record.toMap());
  }

  Future<List<MedicalRecord>> getMedicalRecordsForPatient(int patientId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      medicalRecordTable,
      where: 'patientId = ?',
      whereArgs: [patientId],
    );
    return List.generate(maps.length, (i) {
      return MedicalRecord.fromMap(maps[i]);
    });
  }

  Future<int> updateMedicalRecord(MedicalRecord record) async {
    Database db = await instance.database;
    return await db.update(
      medicalRecordTable,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<List<MedicalRecord>> getAllMedicalRecords() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(medicalRecordTable);
    return List.generate(maps.length, (i) {
      return MedicalRecord.fromMap(maps[i]);
    });
  }

  Future<int> deleteMedicalRecord(int id) async {
    Database db = await instance.database;
    return await db.delete(
      medicalRecordTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> registerUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }
}
