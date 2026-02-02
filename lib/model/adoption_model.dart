class Adoption {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final int petCount;
  final String petName; // ✅ FIXED: Added as class field

  Adoption({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.petCount,
    required this.petName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'petCount': petCount,
      'petName': petName,
    };
  }

  factory Adoption.fromMap(Map<String, dynamic> map) {
    return Adoption(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      petCount: map['petCount'],
      petName: map['petName'] ?? '',
    );
  }
}
