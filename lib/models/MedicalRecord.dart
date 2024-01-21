class MedicalRecord {
  int id;
  String diagnosis;
  int patientId; // Tham chiếu đến Bệnh nhân

  MedicalRecord({
    required this.id,
    required this.diagnosis,
    required this.patientId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diagnosis': diagnosis,
      'patientId': patientId,
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      diagnosis: map['diagnosis'],
      patientId: map['patientId'],
    );
  }

  MedicalRecord copyWith({
    int? id,
    String? diagnosis,
    int? patientId,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      diagnosis: diagnosis ?? this.diagnosis,
      patientId: patientId ?? this.patientId,
    );
  }
}
