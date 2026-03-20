/// Typed user model parsed from API responses.
class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? city;
  final String? role;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.city,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString() ??
          json['profilePicture']?.toString() ??
          json['avatarUrl']?.toString(),
      city: json['city']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
        if (city != null) 'city': city,
        if (role != null) 'role': role,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? city,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        city: city ?? this.city,
        role: role,
      );
}
