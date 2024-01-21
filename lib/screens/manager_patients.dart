import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart';
import 'package:quan_ly_benh_nhan_sqlite/models/Patient.dart';

class ManagerPatients extends StatefulWidget {
  const ManagerPatients({Key? key}) : super(key: key);

  @override
  _ManagerPatientsState createState() => _ManagerPatientsState();
}

class _ManagerPatientsState extends State<ManagerPatients> {
  late List<Patient> patients;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    patients = await DatabaseHelper.instance.getAllPatients();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Điều này sẽ trở về màn hình trước đó
          },
        ),
      ),
      body: patients.isNotEmpty
          ? ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(patients[index].name),
                  subtitle: Text(
                      'Age: ${patients[index].age}, Gender: ${patients[index].gender}'),
                  onTap: () {
                    // Show dialog for editing or deleting patient
                    showEditDeleteDialog(patients[index]);
                  },
                );
              },
            )
          : const Center(
              child: Text('No patients available'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog for adding a new patient
          showAddPatientDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showAddPatientDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Patient newPatient = Patient(
                  id: generateRandomId(),
                  // Set to 0 as it will be auto-incremented by the database
                  name: nameController.text,
                  age: int.tryParse(ageController.text) ?? 0,
                  gender: genderController.text,
                  address: addressController.text,
                );

                await DatabaseHelper.instance.insertPatient(newPatient);
                loadPatients();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  int generateRandomId() {
    Random random = Random();
    return random.nextInt(1000000); // Thay đổi giới hạn theo nhu cầu của bạn
  }

  Future<void> showEditDeleteDialog(Patient patient) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit or Delete Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  showEditPatientDialog(patient);
                },
              ),
              ListTile(
                title: const Text('Delete'),
                onTap: () async {
                  await DatabaseHelper.instance.deletePatient(patient.id);
                  loadPatients();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showEditPatientDialog(Patient patient) async {
    TextEditingController nameController =
        TextEditingController(text: patient.name);
    TextEditingController ageController =
        TextEditingController(text: patient.age.toString());
    TextEditingController genderController =
        TextEditingController(text: patient.gender);
    TextEditingController addressController =
        TextEditingController(text: patient.address);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Patient updatedPatient = Patient(
                  id: patient.id,
                  name: nameController.text,
                  age: int.tryParse(ageController.text) ?? 0,
                  gender: genderController.text,
                  address: addressController.text,
                );

                await DatabaseHelper.instance.updatePatient(updatedPatient);
                loadPatients();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
