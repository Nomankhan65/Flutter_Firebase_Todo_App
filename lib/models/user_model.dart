class UserModel {
  String? uid;
  String? name;
  String? email;
  String? profileImage;
  int? dt;

  UserModel({
      this.uid,
      this.name,
      this.email,
      this.profileImage,
      this.dt,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      dt: map['dt'],
    );
  }
}
