class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? password;
  String? createdAt;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.createdAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    createdAt = json['created_at'] ?? json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (fullName != null) data['full_name'] = fullName;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (createdAt != null) data['created_at'] = createdAt;
    return data;
  }
}