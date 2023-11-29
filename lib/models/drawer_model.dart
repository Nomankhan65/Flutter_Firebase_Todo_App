class Model {
  String name;
  String email;
  String profileImage;
 Model({
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory Model.fromJson(Map<String, dynamic> map) {
    return  Model(
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],

    );
  }
}
