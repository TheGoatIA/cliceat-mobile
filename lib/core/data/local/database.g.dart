// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserPrefsTableTable extends UserPrefsTable
    with TableInfo<$UserPrefsTableTable, UserPrefsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPrefsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fr'),
  );
  static const VerificationMeta _loyaltyPointsMeta = const VerificationMeta(
    'loyaltyPoints',
  );
  @override
  late final GeneratedColumn<int> loyaltyPoints = GeneratedColumn<int>(
    'loyalty_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _walletBalanceMeta = const VerificationMeta(
    'walletBalance',
  );
  @override
  late final GeneratedColumn<double> walletBalance = GeneratedColumn<double>(
    'wallet_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _vehicleTypeMeta = const VerificationMeta(
    'vehicleType',
  );
  @override
  late final GeneratedColumn<String> vehicleType = GeneratedColumn<String>(
    'vehicle_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentModeMeta = const VerificationMeta(
    'currentMode',
  );
  @override
  late final GeneratedColumn<String> currentMode = GeneratedColumn<String>(
    'current_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('client'),
  );
  static const VerificationMeta _fcmTokenMeta = const VerificationMeta(
    'fcmToken',
  );
  @override
  late final GeneratedColumn<String> fcmToken = GeneratedColumn<String>(
    'fcm_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    name,
    email,
    phone,
    city,
    language,
    loyaltyPoints,
    walletBalance,
    vehicleType,
    isOnline,
    currentMode,
    fcmToken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_prefs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPrefsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('loyalty_points')) {
      context.handle(
        _loyaltyPointsMeta,
        loyaltyPoints.isAcceptableOrUnknown(
          data['loyalty_points']!,
          _loyaltyPointsMeta,
        ),
      );
    }
    if (data.containsKey('wallet_balance')) {
      context.handle(
        _walletBalanceMeta,
        walletBalance.isAcceptableOrUnknown(
          data['wallet_balance']!,
          _walletBalanceMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_type')) {
      context.handle(
        _vehicleTypeMeta,
        vehicleType.isAcceptableOrUnknown(
          data['vehicle_type']!,
          _vehicleTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('current_mode')) {
      context.handle(
        _currentModeMeta,
        currentMode.isAcceptableOrUnknown(
          data['current_mode']!,
          _currentModeMeta,
        ),
      );
    }
    if (data.containsKey('fcm_token')) {
      context.handle(
        _fcmTokenMeta,
        fcmToken.isAcceptableOrUnknown(data['fcm_token']!, _fcmTokenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserPrefsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPrefsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      loyaltyPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loyalty_points'],
      )!,
      walletBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wallet_balance'],
      )!,
      vehicleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type'],
      ),
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_online'],
      )!,
      currentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_mode'],
      )!,
      fcmToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fcm_token'],
      ),
    );
  }

  @override
  $UserPrefsTableTable createAlias(String alias) {
    return $UserPrefsTableTable(attachedDatabase, alias);
  }
}

class UserPrefsTableData extends DataClass
    implements Insertable<UserPrefsTableData> {
  final String userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? city;
  final String language;
  final int loyaltyPoints;
  final double walletBalance;
  final String? vehicleType;
  final bool isOnline;
  final String currentMode;
  final String? fcmToken;
  const UserPrefsTableData({
    required this.userId,
    this.name,
    this.email,
    this.phone,
    this.city,
    required this.language,
    required this.loyaltyPoints,
    required this.walletBalance,
    this.vehicleType,
    required this.isOnline,
    required this.currentMode,
    this.fcmToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['language'] = Variable<String>(language);
    map['loyalty_points'] = Variable<int>(loyaltyPoints);
    map['wallet_balance'] = Variable<double>(walletBalance);
    if (!nullToAbsent || vehicleType != null) {
      map['vehicle_type'] = Variable<String>(vehicleType);
    }
    map['is_online'] = Variable<bool>(isOnline);
    map['current_mode'] = Variable<String>(currentMode);
    if (!nullToAbsent || fcmToken != null) {
      map['fcm_token'] = Variable<String>(fcmToken);
    }
    return map;
  }

  UserPrefsTableCompanion toCompanion(bool nullToAbsent) {
    return UserPrefsTableCompanion(
      userId: Value(userId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      language: Value(language),
      loyaltyPoints: Value(loyaltyPoints),
      walletBalance: Value(walletBalance),
      vehicleType: vehicleType == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleType),
      isOnline: Value(isOnline),
      currentMode: Value(currentMode),
      fcmToken: fcmToken == null && nullToAbsent
          ? const Value.absent()
          : Value(fcmToken),
    );
  }

  factory UserPrefsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPrefsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      city: serializer.fromJson<String?>(json['city']),
      language: serializer.fromJson<String>(json['language']),
      loyaltyPoints: serializer.fromJson<int>(json['loyaltyPoints']),
      walletBalance: serializer.fromJson<double>(json['walletBalance']),
      vehicleType: serializer.fromJson<String?>(json['vehicleType']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      currentMode: serializer.fromJson<String>(json['currentMode']),
      fcmToken: serializer.fromJson<String?>(json['fcmToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'city': serializer.toJson<String?>(city),
      'language': serializer.toJson<String>(language),
      'loyaltyPoints': serializer.toJson<int>(loyaltyPoints),
      'walletBalance': serializer.toJson<double>(walletBalance),
      'vehicleType': serializer.toJson<String?>(vehicleType),
      'isOnline': serializer.toJson<bool>(isOnline),
      'currentMode': serializer.toJson<String>(currentMode),
      'fcmToken': serializer.toJson<String?>(fcmToken),
    };
  }

  UserPrefsTableData copyWith({
    String? userId,
    Value<String?> name = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> city = const Value.absent(),
    String? language,
    int? loyaltyPoints,
    double? walletBalance,
    Value<String?> vehicleType = const Value.absent(),
    bool? isOnline,
    String? currentMode,
    Value<String?> fcmToken = const Value.absent(),
  }) => UserPrefsTableData(
    userId: userId ?? this.userId,
    name: name.present ? name.value : this.name,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    city: city.present ? city.value : this.city,
    language: language ?? this.language,
    loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    walletBalance: walletBalance ?? this.walletBalance,
    vehicleType: vehicleType.present ? vehicleType.value : this.vehicleType,
    isOnline: isOnline ?? this.isOnline,
    currentMode: currentMode ?? this.currentMode,
    fcmToken: fcmToken.present ? fcmToken.value : this.fcmToken,
  );
  UserPrefsTableData copyWithCompanion(UserPrefsTableCompanion data) {
    return UserPrefsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      city: data.city.present ? data.city.value : this.city,
      language: data.language.present ? data.language.value : this.language,
      loyaltyPoints: data.loyaltyPoints.present
          ? data.loyaltyPoints.value
          : this.loyaltyPoints,
      walletBalance: data.walletBalance.present
          ? data.walletBalance.value
          : this.walletBalance,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      currentMode: data.currentMode.present
          ? data.currentMode.value
          : this.currentMode,
      fcmToken: data.fcmToken.present ? data.fcmToken.value : this.fcmToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPrefsTableData(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('language: $language, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('isOnline: $isOnline, ')
          ..write('currentMode: $currentMode, ')
          ..write('fcmToken: $fcmToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    name,
    email,
    phone,
    city,
    language,
    loyaltyPoints,
    walletBalance,
    vehicleType,
    isOnline,
    currentMode,
    fcmToken,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPrefsTableData &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.city == this.city &&
          other.language == this.language &&
          other.loyaltyPoints == this.loyaltyPoints &&
          other.walletBalance == this.walletBalance &&
          other.vehicleType == this.vehicleType &&
          other.isOnline == this.isOnline &&
          other.currentMode == this.currentMode &&
          other.fcmToken == this.fcmToken);
}

class UserPrefsTableCompanion extends UpdateCompanion<UserPrefsTableData> {
  final Value<String> userId;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> city;
  final Value<String> language;
  final Value<int> loyaltyPoints;
  final Value<double> walletBalance;
  final Value<String?> vehicleType;
  final Value<bool> isOnline;
  final Value<String> currentMode;
  final Value<String?> fcmToken;
  final Value<int> rowid;
  const UserPrefsTableCompanion({
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.language = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.walletBalance = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.currentMode = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPrefsTableCompanion.insert({
    required String userId,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.language = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.walletBalance = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.currentMode = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserPrefsTableData> custom({
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? city,
    Expression<String>? language,
    Expression<int>? loyaltyPoints,
    Expression<double>? walletBalance,
    Expression<String>? vehicleType,
    Expression<bool>? isOnline,
    Expression<String>? currentMode,
    Expression<String>? fcmToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (language != null) 'language': language,
      if (loyaltyPoints != null) 'loyalty_points': loyaltyPoints,
      if (walletBalance != null) 'wallet_balance': walletBalance,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (isOnline != null) 'is_online': isOnline,
      if (currentMode != null) 'current_mode': currentMode,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPrefsTableCompanion copyWith({
    Value<String>? userId,
    Value<String?>? name,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? city,
    Value<String>? language,
    Value<int>? loyaltyPoints,
    Value<double>? walletBalance,
    Value<String?>? vehicleType,
    Value<bool>? isOnline,
    Value<String>? currentMode,
    Value<String?>? fcmToken,
    Value<int>? rowid,
  }) {
    return UserPrefsTableCompanion(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      language: language ?? this.language,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      walletBalance: walletBalance ?? this.walletBalance,
      vehicleType: vehicleType ?? this.vehicleType,
      isOnline: isOnline ?? this.isOnline,
      currentMode: currentMode ?? this.currentMode,
      fcmToken: fcmToken ?? this.fcmToken,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (loyaltyPoints.present) {
      map['loyalty_points'] = Variable<int>(loyaltyPoints.value);
    }
    if (walletBalance.present) {
      map['wallet_balance'] = Variable<double>(walletBalance.value);
    }
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(vehicleType.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (currentMode.present) {
      map['current_mode'] = Variable<String>(currentMode.value);
    }
    if (fcmToken.present) {
      map['fcm_token'] = Variable<String>(fcmToken.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPrefsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('language: $language, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('isOnline: $isOnline, ')
          ..write('currentMode: $currentMode, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestaurantsTableTable extends RestaurantsTable
    with TableInfo<$RestaurantsTableTable, RestaurantsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cuisineJsonMeta = const VerificationMeta(
    'cuisineJson',
  );
  @override
  late final GeneratedColumn<String> cuisineJson = GeneratedColumn<String>(
    'cuisine_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOpenMeta = const VerificationMeta('isOpen');
  @override
  late final GeneratedColumn<bool> isOpen = GeneratedColumn<bool>(
    'is_open',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_open" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deliveryFeeMeta = const VerificationMeta(
    'deliveryFee',
  );
  @override
  late final GeneratedColumn<double> deliveryFee = GeneratedColumn<double>(
    'delivery_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _minOrderMeta = const VerificationMeta(
    'minOrder',
  );
  @override
  late final GeneratedColumn<double> minOrder = GeneratedColumn<double>(
    'min_order',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgDeliveryTimeMeta = const VerificationMeta(
    'avgDeliveryTime',
  );
  @override
  late final GeneratedColumn<int> avgDeliveryTime = GeneratedColumn<int>(
    'avg_delivery_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    cuisineJson,
    address,
    city,
    lat,
    lng,
    logoUrl,
    coverUrl,
    rating,
    isOpen,
    deliveryFee,
    minOrder,
    avgDeliveryTime,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurants_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestaurantsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cuisine_json')) {
      context.handle(
        _cuisineJsonMeta,
        cuisineJson.isAcceptableOrUnknown(
          data['cuisine_json']!,
          _cuisineJsonMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_open')) {
      context.handle(
        _isOpenMeta,
        isOpen.isAcceptableOrUnknown(data['is_open']!, _isOpenMeta),
      );
    }
    if (data.containsKey('delivery_fee')) {
      context.handle(
        _deliveryFeeMeta,
        deliveryFee.isAcceptableOrUnknown(
          data['delivery_fee']!,
          _deliveryFeeMeta,
        ),
      );
    }
    if (data.containsKey('min_order')) {
      context.handle(
        _minOrderMeta,
        minOrder.isAcceptableOrUnknown(data['min_order']!, _minOrderMeta),
      );
    }
    if (data.containsKey('avg_delivery_time')) {
      context.handle(
        _avgDeliveryTimeMeta,
        avgDeliveryTime.isAcceptableOrUnknown(
          data['avg_delivery_time']!,
          _avgDeliveryTimeMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      cuisineJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine_json'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      isOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_open'],
      )!,
      deliveryFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_fee'],
      )!,
      minOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_order'],
      )!,
      avgDeliveryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_delivery_time'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $RestaurantsTableTable createAlias(String alias) {
    return $RestaurantsTableTable(attachedDatabase, alias);
  }
}

class RestaurantsTableData extends DataClass
    implements Insertable<RestaurantsTableData> {
  final String id;
  final String name;
  final String? description;
  final String? cuisineJson;
  final String? address;
  final String city;
  final double lat;
  final double lng;
  final String? logoUrl;
  final String? coverUrl;
  final double? rating;
  final bool isOpen;
  final double deliveryFee;
  final double minOrder;
  final int? avgDeliveryTime;
  final DateTime cachedAt;
  const RestaurantsTableData({
    required this.id,
    required this.name,
    this.description,
    this.cuisineJson,
    this.address,
    required this.city,
    required this.lat,
    required this.lng,
    this.logoUrl,
    this.coverUrl,
    this.rating,
    required this.isOpen,
    required this.deliveryFee,
    required this.minOrder,
    this.avgDeliveryTime,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || cuisineJson != null) {
      map['cuisine_json'] = Variable<String>(cuisineJson);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['city'] = Variable<String>(city);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['is_open'] = Variable<bool>(isOpen);
    map['delivery_fee'] = Variable<double>(deliveryFee);
    map['min_order'] = Variable<double>(minOrder);
    if (!nullToAbsent || avgDeliveryTime != null) {
      map['avg_delivery_time'] = Variable<int>(avgDeliveryTime);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  RestaurantsTableCompanion toCompanion(bool nullToAbsent) {
    return RestaurantsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      cuisineJson: cuisineJson == null && nullToAbsent
          ? const Value.absent()
          : Value(cuisineJson),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: Value(city),
      lat: Value(lat),
      lng: Value(lng),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isOpen: Value(isOpen),
      deliveryFee: Value(deliveryFee),
      minOrder: Value(minOrder),
      avgDeliveryTime: avgDeliveryTime == null && nullToAbsent
          ? const Value.absent()
          : Value(avgDeliveryTime),
      cachedAt: Value(cachedAt),
    );
  }

  factory RestaurantsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      cuisineJson: serializer.fromJson<String?>(json['cuisineJson']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String>(json['city']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      rating: serializer.fromJson<double?>(json['rating']),
      isOpen: serializer.fromJson<bool>(json['isOpen']),
      deliveryFee: serializer.fromJson<double>(json['deliveryFee']),
      minOrder: serializer.fromJson<double>(json['minOrder']),
      avgDeliveryTime: serializer.fromJson<int?>(json['avgDeliveryTime']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'cuisineJson': serializer.toJson<String?>(cuisineJson),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String>(city),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'rating': serializer.toJson<double?>(rating),
      'isOpen': serializer.toJson<bool>(isOpen),
      'deliveryFee': serializer.toJson<double>(deliveryFee),
      'minOrder': serializer.toJson<double>(minOrder),
      'avgDeliveryTime': serializer.toJson<int?>(avgDeliveryTime),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  RestaurantsTableData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> cuisineJson = const Value.absent(),
    Value<String?> address = const Value.absent(),
    String? city,
    double? lat,
    double? lng,
    Value<String?> logoUrl = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    bool? isOpen,
    double? deliveryFee,
    double? minOrder,
    Value<int?> avgDeliveryTime = const Value.absent(),
    DateTime? cachedAt,
  }) => RestaurantsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    cuisineJson: cuisineJson.present ? cuisineJson.value : this.cuisineJson,
    address: address.present ? address.value : this.address,
    city: city ?? this.city,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    rating: rating.present ? rating.value : this.rating,
    isOpen: isOpen ?? this.isOpen,
    deliveryFee: deliveryFee ?? this.deliveryFee,
    minOrder: minOrder ?? this.minOrder,
    avgDeliveryTime: avgDeliveryTime.present
        ? avgDeliveryTime.value
        : this.avgDeliveryTime,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  RestaurantsTableData copyWithCompanion(RestaurantsTableCompanion data) {
    return RestaurantsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      cuisineJson: data.cuisineJson.present
          ? data.cuisineJson.value
          : this.cuisineJson,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      rating: data.rating.present ? data.rating.value : this.rating,
      isOpen: data.isOpen.present ? data.isOpen.value : this.isOpen,
      deliveryFee: data.deliveryFee.present
          ? data.deliveryFee.value
          : this.deliveryFee,
      minOrder: data.minOrder.present ? data.minOrder.value : this.minOrder,
      avgDeliveryTime: data.avgDeliveryTime.present
          ? data.avgDeliveryTime.value
          : this.avgDeliveryTime,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisineJson: $cuisineJson, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('rating: $rating, ')
          ..write('isOpen: $isOpen, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('minOrder: $minOrder, ')
          ..write('avgDeliveryTime: $avgDeliveryTime, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    cuisineJson,
    address,
    city,
    lat,
    lng,
    logoUrl,
    coverUrl,
    rating,
    isOpen,
    deliveryFee,
    minOrder,
    avgDeliveryTime,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.cuisineJson == this.cuisineJson &&
          other.address == this.address &&
          other.city == this.city &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.logoUrl == this.logoUrl &&
          other.coverUrl == this.coverUrl &&
          other.rating == this.rating &&
          other.isOpen == this.isOpen &&
          other.deliveryFee == this.deliveryFee &&
          other.minOrder == this.minOrder &&
          other.avgDeliveryTime == this.avgDeliveryTime &&
          other.cachedAt == this.cachedAt);
}

class RestaurantsTableCompanion extends UpdateCompanion<RestaurantsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> cuisineJson;
  final Value<String?> address;
  final Value<String> city;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String?> logoUrl;
  final Value<String?> coverUrl;
  final Value<double?> rating;
  final Value<bool> isOpen;
  final Value<double> deliveryFee;
  final Value<double> minOrder;
  final Value<int?> avgDeliveryTime;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const RestaurantsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.cuisineJson = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.minOrder = const Value.absent(),
    this.avgDeliveryTime = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestaurantsTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.cuisineJson = const Value.absent(),
    this.address = const Value.absent(),
    required String city,
    required double lat,
    required double lng,
    this.logoUrl = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.minOrder = const Value.absent(),
    this.avgDeliveryTime = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       city = Value(city),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<RestaurantsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? cuisineJson,
    Expression<String>? address,
    Expression<String>? city,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? logoUrl,
    Expression<String>? coverUrl,
    Expression<double>? rating,
    Expression<bool>? isOpen,
    Expression<double>? deliveryFee,
    Expression<double>? minOrder,
    Expression<int>? avgDeliveryTime,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (cuisineJson != null) 'cuisine_json': cuisineJson,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (rating != null) 'rating': rating,
      if (isOpen != null) 'is_open': isOpen,
      if (deliveryFee != null) 'delivery_fee': deliveryFee,
      if (minOrder != null) 'min_order': minOrder,
      if (avgDeliveryTime != null) 'avg_delivery_time': avgDeliveryTime,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestaurantsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? cuisineJson,
    Value<String?>? address,
    Value<String>? city,
    Value<double>? lat,
    Value<double>? lng,
    Value<String?>? logoUrl,
    Value<String?>? coverUrl,
    Value<double?>? rating,
    Value<bool>? isOpen,
    Value<double>? deliveryFee,
    Value<double>? minOrder,
    Value<int?>? avgDeliveryTime,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return RestaurantsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisineJson: cuisineJson ?? this.cuisineJson,
      address: address ?? this.address,
      city: city ?? this.city,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrder: minOrder ?? this.minOrder,
      avgDeliveryTime: avgDeliveryTime ?? this.avgDeliveryTime,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cuisineJson.present) {
      map['cuisine_json'] = Variable<String>(cuisineJson.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isOpen.present) {
      map['is_open'] = Variable<bool>(isOpen.value);
    }
    if (deliveryFee.present) {
      map['delivery_fee'] = Variable<double>(deliveryFee.value);
    }
    if (minOrder.present) {
      map['min_order'] = Variable<double>(minOrder.value);
    }
    if (avgDeliveryTime.present) {
      map['avg_delivery_time'] = Variable<int>(avgDeliveryTime.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisineJson: $cuisineJson, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('rating: $rating, ')
          ..write('isOpen: $isOpen, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('minOrder: $minOrder, ')
          ..write('avgDeliveryTime: $avgDeliveryTime, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartTableTable extends CartTable
    with TableInfo<$CartTableTable, CartTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restaurantIdMeta = const VerificationMeta(
    'restaurantId',
  );
  @override
  late final GeneratedColumn<String> restaurantId = GeneratedColumn<String>(
    'restaurant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _variationJsonMeta = const VerificationMeta(
    'variationJson',
  );
  @override
  late final GeneratedColumn<String> variationJson = GeneratedColumn<String>(
    'variation_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addonJsonMeta = const VerificationMeta(
    'addonJson',
  );
  @override
  late final GeneratedColumn<String> addonJson = GeneratedColumn<String>(
    'addon_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    restaurantId,
    itemId,
    name,
    price,
    quantity,
    variationJson,
    addonJson,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('restaurant_id')) {
      context.handle(
        _restaurantIdMeta,
        restaurantId.isAcceptableOrUnknown(
          data['restaurant_id']!,
          _restaurantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restaurantIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('variation_json')) {
      context.handle(
        _variationJsonMeta,
        variationJson.isAcceptableOrUnknown(
          data['variation_json']!,
          _variationJsonMeta,
        ),
      );
    }
    if (data.containsKey('addon_json')) {
      context.handle(
        _addonJsonMeta,
        addonJson.isAcceptableOrUnknown(data['addon_json']!, _addonJsonMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      restaurantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restaurant_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      variationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variation_json'],
      ),
      addonJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addon_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CartTableTable createAlias(String alias) {
    return $CartTableTable(attachedDatabase, alias);
  }
}

class CartTableData extends DataClass implements Insertable<CartTableData> {
  final String id;
  final String restaurantId;
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String? variationJson;
  final String? addonJson;
  final String? notes;
  const CartTableData({
    required this.id,
    required this.restaurantId,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.variationJson,
    this.addonJson,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['restaurant_id'] = Variable<String>(restaurantId);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || variationJson != null) {
      map['variation_json'] = Variable<String>(variationJson);
    }
    if (!nullToAbsent || addonJson != null) {
      map['addon_json'] = Variable<String>(addonJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CartTableCompanion toCompanion(bool nullToAbsent) {
    return CartTableCompanion(
      id: Value(id),
      restaurantId: Value(restaurantId),
      itemId: Value(itemId),
      name: Value(name),
      price: Value(price),
      quantity: Value(quantity),
      variationJson: variationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(variationJson),
      addonJson: addonJson == null && nullToAbsent
          ? const Value.absent()
          : Value(addonJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory CartTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartTableData(
      id: serializer.fromJson<String>(json['id']),
      restaurantId: serializer.fromJson<String>(json['restaurantId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
      variationJson: serializer.fromJson<String?>(json['variationJson']),
      addonJson: serializer.fromJson<String?>(json['addonJson']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'restaurantId': serializer.toJson<String>(restaurantId),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int>(quantity),
      'variationJson': serializer.toJson<String?>(variationJson),
      'addonJson': serializer.toJson<String?>(addonJson),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CartTableData copyWith({
    String? id,
    String? restaurantId,
    String? itemId,
    String? name,
    double? price,
    int? quantity,
    Value<String?> variationJson = const Value.absent(),
    Value<String?> addonJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => CartTableData(
    id: id ?? this.id,
    restaurantId: restaurantId ?? this.restaurantId,
    itemId: itemId ?? this.itemId,
    name: name ?? this.name,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    variationJson: variationJson.present
        ? variationJson.value
        : this.variationJson,
    addonJson: addonJson.present ? addonJson.value : this.addonJson,
    notes: notes.present ? notes.value : this.notes,
  );
  CartTableData copyWithCompanion(CartTableCompanion data) {
    return CartTableData(
      id: data.id.present ? data.id.value : this.id,
      restaurantId: data.restaurantId.present
          ? data.restaurantId.value
          : this.restaurantId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      variationJson: data.variationJson.present
          ? data.variationJson.value
          : this.variationJson,
      addonJson: data.addonJson.present ? data.addonJson.value : this.addonJson,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartTableData(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('variationJson: $variationJson, ')
          ..write('addonJson: $addonJson, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    restaurantId,
    itemId,
    name,
    price,
    quantity,
    variationJson,
    addonJson,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartTableData &&
          other.id == this.id &&
          other.restaurantId == this.restaurantId &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.variationJson == this.variationJson &&
          other.addonJson == this.addonJson &&
          other.notes == this.notes);
}

class CartTableCompanion extends UpdateCompanion<CartTableData> {
  final Value<String> id;
  final Value<String> restaurantId;
  final Value<String> itemId;
  final Value<String> name;
  final Value<double> price;
  final Value<int> quantity;
  final Value<String?> variationJson;
  final Value<String?> addonJson;
  final Value<String?> notes;
  final Value<int> rowid;
  const CartTableCompanion({
    this.id = const Value.absent(),
    this.restaurantId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.variationJson = const Value.absent(),
    this.addonJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartTableCompanion.insert({
    required String id,
    required String restaurantId,
    required String itemId,
    required String name,
    required double price,
    this.quantity = const Value.absent(),
    this.variationJson = const Value.absent(),
    this.addonJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       restaurantId = Value(restaurantId),
       itemId = Value(itemId),
       name = Value(name),
       price = Value(price);
  static Insertable<CartTableData> custom({
    Expression<String>? id,
    Expression<String>? restaurantId,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<int>? quantity,
    Expression<String>? variationJson,
    Expression<String>? addonJson,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (restaurantId != null) 'restaurant_id': restaurantId,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (variationJson != null) 'variation_json': variationJson,
      if (addonJson != null) 'addon_json': addonJson,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartTableCompanion copyWith({
    Value<String>? id,
    Value<String>? restaurantId,
    Value<String>? itemId,
    Value<String>? name,
    Value<double>? price,
    Value<int>? quantity,
    Value<String?>? variationJson,
    Value<String?>? addonJson,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return CartTableCompanion(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      variationJson: variationJson ?? this.variationJson,
      addonJson: addonJson ?? this.addonJson,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (restaurantId.present) {
      map['restaurant_id'] = Variable<String>(restaurantId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (variationJson.present) {
      map['variation_json'] = Variable<String>(variationJson.value);
    }
    if (addonJson.present) {
      map['addon_json'] = Variable<String>(addonJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartTableCompanion(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('variationJson: $variationJson, ')
          ..write('addonJson: $addonJson, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserPrefsTableTable userPrefsTable = $UserPrefsTableTable(this);
  late final $RestaurantsTableTable restaurantsTable = $RestaurantsTableTable(
    this,
  );
  late final $CartTableTable cartTable = $CartTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userPrefsTable,
    restaurantsTable,
    cartTable,
  ];
}

typedef $$UserPrefsTableTableCreateCompanionBuilder =
    UserPrefsTableCompanion Function({
      required String userId,
      Value<String?> name,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> city,
      Value<String> language,
      Value<int> loyaltyPoints,
      Value<double> walletBalance,
      Value<String?> vehicleType,
      Value<bool> isOnline,
      Value<String> currentMode,
      Value<String?> fcmToken,
      Value<int> rowid,
    });
typedef $$UserPrefsTableTableUpdateCompanionBuilder =
    UserPrefsTableCompanion Function({
      Value<String> userId,
      Value<String?> name,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> city,
      Value<String> language,
      Value<int> loyaltyPoints,
      Value<double> walletBalance,
      Value<String?> vehicleType,
      Value<bool> isOnline,
      Value<String> currentMode,
      Value<String?> fcmToken,
      Value<int> rowid,
    });

class $$UserPrefsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPrefsTableTable> {
  $$UserPrefsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentMode => $composableBuilder(
    column: $table.currentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPrefsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPrefsTableTable> {
  $$UserPrefsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentMode => $composableBuilder(
    column: $table.currentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPrefsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPrefsTableTable> {
  $$UserPrefsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => column,
  );

  GeneratedColumn<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<String> get currentMode => $composableBuilder(
    column: $table.currentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fcmToken =>
      $composableBuilder(column: $table.fcmToken, builder: (column) => column);
}

class $$UserPrefsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPrefsTableTable,
          UserPrefsTableData,
          $$UserPrefsTableTableFilterComposer,
          $$UserPrefsTableTableOrderingComposer,
          $$UserPrefsTableTableAnnotationComposer,
          $$UserPrefsTableTableCreateCompanionBuilder,
          $$UserPrefsTableTableUpdateCompanionBuilder,
          (
            UserPrefsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserPrefsTableTable,
              UserPrefsTableData
            >,
          ),
          UserPrefsTableData,
          PrefetchHooks Function()
        > {
  $$UserPrefsTableTableTableManager(
    _$AppDatabase db,
    $UserPrefsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPrefsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPrefsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPrefsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<double> walletBalance = const Value.absent(),
                Value<String?> vehicleType = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String> currentMode = const Value.absent(),
                Value<String?> fcmToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPrefsTableCompanion(
                userId: userId,
                name: name,
                email: email,
                phone: phone,
                city: city,
                language: language,
                loyaltyPoints: loyaltyPoints,
                walletBalance: walletBalance,
                vehicleType: vehicleType,
                isOnline: isOnline,
                currentMode: currentMode,
                fcmToken: fcmToken,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<double> walletBalance = const Value.absent(),
                Value<String?> vehicleType = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String> currentMode = const Value.absent(),
                Value<String?> fcmToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPrefsTableCompanion.insert(
                userId: userId,
                name: name,
                email: email,
                phone: phone,
                city: city,
                language: language,
                loyaltyPoints: loyaltyPoints,
                walletBalance: walletBalance,
                vehicleType: vehicleType,
                isOnline: isOnline,
                currentMode: currentMode,
                fcmToken: fcmToken,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPrefsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPrefsTableTable,
      UserPrefsTableData,
      $$UserPrefsTableTableFilterComposer,
      $$UserPrefsTableTableOrderingComposer,
      $$UserPrefsTableTableAnnotationComposer,
      $$UserPrefsTableTableCreateCompanionBuilder,
      $$UserPrefsTableTableUpdateCompanionBuilder,
      (
        UserPrefsTableData,
        BaseReferences<_$AppDatabase, $UserPrefsTableTable, UserPrefsTableData>,
      ),
      UserPrefsTableData,
      PrefetchHooks Function()
    >;
typedef $$RestaurantsTableTableCreateCompanionBuilder =
    RestaurantsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String?> cuisineJson,
      Value<String?> address,
      required String city,
      required double lat,
      required double lng,
      Value<String?> logoUrl,
      Value<String?> coverUrl,
      Value<double?> rating,
      Value<bool> isOpen,
      Value<double> deliveryFee,
      Value<double> minOrder,
      Value<int?> avgDeliveryTime,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$RestaurantsTableTableUpdateCompanionBuilder =
    RestaurantsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> cuisineJson,
      Value<String?> address,
      Value<String> city,
      Value<double> lat,
      Value<double> lng,
      Value<String?> logoUrl,
      Value<String?> coverUrl,
      Value<double?> rating,
      Value<bool> isOpen,
      Value<double> deliveryFee,
      Value<double> minOrder,
      Value<int?> avgDeliveryTime,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$RestaurantsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantsTableTable> {
  $$RestaurantsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisineJson => $composableBuilder(
    column: $table.cuisineJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minOrder => $composableBuilder(
    column: $table.minOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgDeliveryTime => $composableBuilder(
    column: $table.avgDeliveryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestaurantsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantsTableTable> {
  $$RestaurantsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisineJson => $composableBuilder(
    column: $table.cuisineJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minOrder => $composableBuilder(
    column: $table.minOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgDeliveryTime => $composableBuilder(
    column: $table.avgDeliveryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestaurantsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantsTableTable> {
  $$RestaurantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisineJson => $composableBuilder(
    column: $table.cuisineJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isOpen =>
      $composableBuilder(column: $table.isOpen, builder: (column) => column);

  GeneratedColumn<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minOrder =>
      $composableBuilder(column: $table.minOrder, builder: (column) => column);

  GeneratedColumn<int> get avgDeliveryTime => $composableBuilder(
    column: $table.avgDeliveryTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$RestaurantsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestaurantsTableTable,
          RestaurantsTableData,
          $$RestaurantsTableTableFilterComposer,
          $$RestaurantsTableTableOrderingComposer,
          $$RestaurantsTableTableAnnotationComposer,
          $$RestaurantsTableTableCreateCompanionBuilder,
          $$RestaurantsTableTableUpdateCompanionBuilder,
          (
            RestaurantsTableData,
            BaseReferences<
              _$AppDatabase,
              $RestaurantsTableTable,
              RestaurantsTableData
            >,
          ),
          RestaurantsTableData,
          PrefetchHooks Function()
        > {
  $$RestaurantsTableTableTableManager(
    _$AppDatabase db,
    $RestaurantsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> cuisineJson = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isOpen = const Value.absent(),
                Value<double> deliveryFee = const Value.absent(),
                Value<double> minOrder = const Value.absent(),
                Value<int?> avgDeliveryTime = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestaurantsTableCompanion(
                id: id,
                name: name,
                description: description,
                cuisineJson: cuisineJson,
                address: address,
                city: city,
                lat: lat,
                lng: lng,
                logoUrl: logoUrl,
                coverUrl: coverUrl,
                rating: rating,
                isOpen: isOpen,
                deliveryFee: deliveryFee,
                minOrder: minOrder,
                avgDeliveryTime: avgDeliveryTime,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> cuisineJson = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required String city,
                required double lat,
                required double lng,
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isOpen = const Value.absent(),
                Value<double> deliveryFee = const Value.absent(),
                Value<double> minOrder = const Value.absent(),
                Value<int?> avgDeliveryTime = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestaurantsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                cuisineJson: cuisineJson,
                address: address,
                city: city,
                lat: lat,
                lng: lng,
                logoUrl: logoUrl,
                coverUrl: coverUrl,
                rating: rating,
                isOpen: isOpen,
                deliveryFee: deliveryFee,
                minOrder: minOrder,
                avgDeliveryTime: avgDeliveryTime,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestaurantsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestaurantsTableTable,
      RestaurantsTableData,
      $$RestaurantsTableTableFilterComposer,
      $$RestaurantsTableTableOrderingComposer,
      $$RestaurantsTableTableAnnotationComposer,
      $$RestaurantsTableTableCreateCompanionBuilder,
      $$RestaurantsTableTableUpdateCompanionBuilder,
      (
        RestaurantsTableData,
        BaseReferences<
          _$AppDatabase,
          $RestaurantsTableTable,
          RestaurantsTableData
        >,
      ),
      RestaurantsTableData,
      PrefetchHooks Function()
    >;
typedef $$CartTableTableCreateCompanionBuilder =
    CartTableCompanion Function({
      required String id,
      required String restaurantId,
      required String itemId,
      required String name,
      required double price,
      Value<int> quantity,
      Value<String?> variationJson,
      Value<String?> addonJson,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$CartTableTableUpdateCompanionBuilder =
    CartTableCompanion Function({
      Value<String> id,
      Value<String> restaurantId,
      Value<String> itemId,
      Value<String> name,
      Value<double> price,
      Value<int> quantity,
      Value<String?> variationJson,
      Value<String?> addonJson,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$CartTableTableFilterComposer
    extends Composer<_$AppDatabase, $CartTableTable> {
  $$CartTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variationJson => $composableBuilder(
    column: $table.variationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addonJson => $composableBuilder(
    column: $table.addonJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CartTableTable> {
  $$CartTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variationJson => $composableBuilder(
    column: $table.variationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addonJson => $composableBuilder(
    column: $table.addonJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartTableTable> {
  $$CartTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get variationJson => $composableBuilder(
    column: $table.variationJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addonJson =>
      $composableBuilder(column: $table.addonJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CartTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartTableTable,
          CartTableData,
          $$CartTableTableFilterComposer,
          $$CartTableTableOrderingComposer,
          $$CartTableTableAnnotationComposer,
          $$CartTableTableCreateCompanionBuilder,
          $$CartTableTableUpdateCompanionBuilder,
          (
            CartTableData,
            BaseReferences<_$AppDatabase, $CartTableTable, CartTableData>,
          ),
          CartTableData,
          PrefetchHooks Function()
        > {
  $$CartTableTableTableManager(_$AppDatabase db, $CartTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> restaurantId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> variationJson = const Value.absent(),
                Value<String?> addonJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartTableCompanion(
                id: id,
                restaurantId: restaurantId,
                itemId: itemId,
                name: name,
                price: price,
                quantity: quantity,
                variationJson: variationJson,
                addonJson: addonJson,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String restaurantId,
                required String itemId,
                required String name,
                required double price,
                Value<int> quantity = const Value.absent(),
                Value<String?> variationJson = const Value.absent(),
                Value<String?> addonJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartTableCompanion.insert(
                id: id,
                restaurantId: restaurantId,
                itemId: itemId,
                name: name,
                price: price,
                quantity: quantity,
                variationJson: variationJson,
                addonJson: addonJson,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartTableTable,
      CartTableData,
      $$CartTableTableFilterComposer,
      $$CartTableTableOrderingComposer,
      $$CartTableTableAnnotationComposer,
      $$CartTableTableCreateCompanionBuilder,
      $$CartTableTableUpdateCompanionBuilder,
      (
        CartTableData,
        BaseReferences<_$AppDatabase, $CartTableTable, CartTableData>,
      ),
      CartTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserPrefsTableTableTableManager get userPrefsTable =>
      $$UserPrefsTableTableTableManager(_db, _db.userPrefsTable);
  $$RestaurantsTableTableTableManager get restaurantsTable =>
      $$RestaurantsTableTableTableManager(_db, _db.restaurantsTable);
  $$CartTableTableTableManager get cartTable =>
      $$CartTableTableTableManager(_db, _db.cartTable);
}
