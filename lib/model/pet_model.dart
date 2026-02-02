class petmodel {
  List<Data>? data;

  petmodel({this.data});

  petmodel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? userName;
  String? petName;
  String? petImage;
  bool? isfriendly;
  String? category; // ✅ FIXED: Added category field

  Data({
    this.id,
    this.userName,
    this.petName,
    this.petImage,
    this.isfriendly,
    this.category, // ✅ FIXED: Added to constructor
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    petName = json['petName'];
    petImage = json['petImage'];
    isfriendly = json['isFriendly'];
    category = json['category'] ?? 'Dog';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['petName'] = this.petName;
    data['petImage'] = this.petImage;
    data['isFriendly'] = this.isfriendly;
    data['category'] = this.category;
    return data;
  }
}
