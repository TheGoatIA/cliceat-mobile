/// Typed user model parsed from API responses.
class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? city;
  final String? role;
  final double? balance;
  final String? vehicleType;
  final String? vehiclePlate;
  final Map<String, dynamic>? notificationPreferences;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.city,
    this.role,
    this.balance,
    this.vehicleType,
    this.vehiclePlate,
    this.notificationPreferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      avatar:
          json['avatar']?.toString() ??
          json['profilePicture']?.toString() ??
          json['avatarUrl']?.toString() ??
          json['photoUrl']?.toString(),
      city: json['city']?.toString(),
      role: json['role']?.toString(),
      balance: ((json['balance'] ?? json['walletBalance'] ?? json['wallet']?['balance'] ?? 0) as num).toDouble(),
      vehicleType: json['vehicleType']?.toString(),
      vehiclePlate: json['vehiclePlate']?.toString(),
      notificationPreferences:
          json['notificationPreferences'] as Map<String, dynamic>?,
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
    'balance': balance ?? 0.0,
    if (vehicleType != null) 'vehicleType': vehicleType,
    if (vehiclePlate != null) 'vehiclePlate': vehiclePlate,
    if (notificationPreferences != null)
      'notificationPreferences': notificationPreferences,
  };

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? city,
    double? balance,
    String? vehicleType,
    String? vehiclePlate,
    Map<String, dynamic>? notificationPreferences,
  }) => UserModel(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    avatar: avatar ?? this.avatar,
    city: city ?? this.city,
    balance: balance ?? this.balance,
    role: role,
    vehicleType: vehicleType ?? this.vehicleType,
    vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    notificationPreferences:
        notificationPreferences ?? this.notificationPreferences,
  );
}
