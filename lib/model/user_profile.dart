class UserProfile {
  UserProfile({
    this.id,
    required this.name,
    required this.emailId,
    required this.password,
    required this.createdDate,
    this.profileimage,
  });

  String? id;
  String? name;
  String? emailId;
  String? password;
  String? createdDate;
  String? profileimage;

  UserProfile copyWith({
    String? id,
    String? name,
    String? emailId,
    String? password,
    String? createdDate,
    String? profileimage,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      emailId: emailId ?? this.emailId,
      password: password ?? this.password,
      createdDate: createdDate ?? this.createdDate,
      profileimage: profileimage ?? this.profileimage,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String?,
      name: json['name'] as String,
      emailId: json['emailId'] as String,
      password: json['password'] as String,
      createdDate: json['createdDate'] as String,
      profileimage: json['profileimage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emailId': emailId,
      'password': password,
      'createdDate': createdDate,
      'profileimage': profileimage,
    };
  }
}
