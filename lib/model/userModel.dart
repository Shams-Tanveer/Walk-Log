final String userTable ="users";

class UserField{
  static const String id= "id";
  static const String uniqueId= "uniqueId";
  static const String height= "height";
  static const String weight= "weight";
  static const String gender= "gender";
}

class User{
  String? id;
  String uniqueId;
  double height;
  double weight;
  String gender;


  User({
    this.id,
    required this.uniqueId,
    required this.height,
    required this.weight,
    required this.gender
  });

  Map<String, dynamic> toJson()=>{
    UserField.id: id,
    UserField.uniqueId: uniqueId,
    UserField.height: height,
    UserField.weight: weight,
    UserField.gender: gender
  };

  static User fromJson(Map<String, Object?> json) =>User(
    id: json[UserField.id] as String,
    uniqueId: json[UserField.uniqueId] as String, 
    height: json[UserField.height] as double, 
    weight: json[UserField.weight] as double, 
    gender: json[UserField.gender] as String);
}