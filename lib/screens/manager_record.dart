import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart';
import 'package:quan_ly_benh_nhan_sqlite/models/MedicalRecord.dart';
import 'package:quan_ly_benh_nhan_sqlite/models/Patient.dart';

class ManagerRecord extends StatefulWidget {
  const ManagerRecord({Key? key}) : super(key: key);

  @override
  State<ManagerRecord> createState() => _ManagerRecordState();
}

class _ManagerRecordState extends State<ManagerRecord> {
  late List<MedicalRecord> medicalRecords;
  late List<Patient> patients;
  late TextEditingController diagnosisController;
  int? selectedPatientId;

  @override
  void initState() {
    super.initState();
    diagnosisController = TextEditingController();

    // Initialize patients before accessing it
    patients = [];

    // Load patients before rendering the dropdown
    loadPatients().then((_) {
      // Check if there are patients available
      if (patients.isNotEmpty) {
        // Use the first patient as the initial value
        selectedPatientId = patients.first.id;
      } else {
        // If no patients, set to null or any other appropriate default value
        selectedPatientId = null;
      }

      // Load medical records after patients are loaded
      loadMedicalRecords();
    });
  }

  Future<void> loadMedicalRecords() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    medicalRecords = await dbHelper.getAllMedicalRecords();
    setState(() {}); // Refresh the UI after loading medical records
  }

  Future<void> loadPatients() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    patients = await dbHelper.getAllPatients();
    setState(() {}); // Refresh the UI after loading patients
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Quản lý bệnh án'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Điều này sẽ trở về màn hình trước đó
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Spinner for selecting patient
            DropdownButtonFormField<int>(
              value: selectedPatientId,
              items: patients.map((patient) {
                return DropdownMenuItem<int>(
                  value: patient.id,
                  child: Text(patient.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPatientId =
                      value; // The value is not nullable, and DropdownButtonFormField will handle null case
                });
              },
            ),

            const SizedBox(height: 16.0),
            // TextField for entering diagnosis
            TextField(
              controller: diagnosisController,
              decoration: InputDecoration(
                labelText: 'Chẩn đoán',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (selectedPatientId != null) {
                  MedicalRecord newRecord = MedicalRecord(
                    id: generateRandomId(),
                    diagnosis: diagnosisController.text,
                    patientId: selectedPatientId!,
                  );

                  await DatabaseHelper.instance.insertMedicalRecord(newRecord);
                  loadMedicalRecords();
                }
              },
              child: const Text('Lưu'),
            ),
            const SizedBox(height: 16.0),
            // ListView for displaying medical records
            Expanded(
              child: medicalRecords.isNotEmpty
                  ? ListView.builder(
                      itemCount: medicalRecords.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Diagnosis: ${medicalRecords[index].diagnosis}',
                          ),
                          subtitle: Text(
                            'Patient: ${medicalRecords[index].patientId}',
                          ),
                          // Add more medical record details as needed
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit button tap
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      diagnosisController.text =
                                          medicalRecords[index].diagnosis;

                                      return AlertDialog(
                                        title:
                                            const Text('Edit Medical Record'),
                                        content: TextField(
                                          controller: diagnosisController,
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
                                              MedicalRecord updatedRecord =
                                                  medicalRecords[index]
                                                      .copyWith(
                                                diagnosis:
                                                    diagnosisController.text,
                                              );

                                              await DatabaseHelper.instance
                                                  .updateMedicalRecord(
                                                      updatedRecord);
                                              loadMedicalRecords();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Handle delete button tap
                                  await DatabaseHelper.instance
                                      .deleteMedicalRecord(
                                          medicalRecords[index].id);
                                  loadMedicalRecords();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No medical records available'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int generateRandomId() {
    Random random = Random();
    return random.nextInt(1000000); // Thay đổi giới hạn theo nhu cầu của bạn
  }
}
