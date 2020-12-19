class UserApp {
  String fullName;
  String username;
  String password;
  String avatar;
  String gender;
  String birthday;
  String phone;
  String address;
  String create_at;
  String id_scripe;
  String type;
  UserApp(
      this.fullName,
      this.username,
      this.password,
      this.gender,
      this.birthday,
      this.phone,
      this.address,
      this.create_at,
      this.id_scripe,
      this.type,
      this.avatar);

  UserApp.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    password = json['password'];
    avatar = json['avatar'];
    gender = json['gender'];
    birthday = json['birthday'];
    phone = json['phone'];
    address = json['address'];
    create_at = json['create_at'];
    id_scripe = json['id_scripe'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = fullName;
    data['username'] = username;
    data['password'] = password;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['birthday'] = birthday;
    data['phone'] = phone;
    data['address'] = address;
    data['create_at'] = create_at;
    data['id_scripe'] = id_scripe;
    data['type'] = type;
    return data;
  }
}
