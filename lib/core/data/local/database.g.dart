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
  static const VerificationMeta _isDarkModeMeta = const VerificationMeta(
    'isDarkMode',
  );
  @override
  late final GeneratedColumn<bool> isDarkMode = GeneratedColumn<bool>(
    'is_dark_mode',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dark_mode" IN (0, 1))',
    ),
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
    isDarkMode,
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
    if (data.containsKey('is_dark_mode')) {
      context.handle(
        _isDarkModeMeta,
        isDarkMode.isAcceptableOrUnknown(
          data['is_dark_mode']!,
          _isDarkModeMeta,
        ),
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
      isDarkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dark_mode'],
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
  final bool? isDarkMode;
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
    this.isDarkMode,
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
    if (!nullToAbsent || isDarkMode != null) {
      map['is_dark_mode'] = Variable<bool>(isDarkMode);
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
      isDarkMode: isDarkMode == null && nullToAbsent
          ? const Value.absent()
          : Value(isDarkMode),
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
      isDarkMode: serializer.fromJson<bool?>(json['isDarkMode']),
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
      'isDarkMode': serializer.toJson<bool?>(isDarkMode),
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
    Value<bool?> isDarkMode = const Value.absent(),
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
    isDarkMode: isDarkMode.present ? isDarkMode.value : this.isDarkMode,
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
      isDarkMode: data.isDarkMode.present
          ? data.isDarkMode.value
          : this.isDarkMode,
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
          ..write('fcmToken: $fcmToken, ')
          ..write('isDarkMode: $isDarkMode')
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
    isDarkMode,
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
          other.fcmToken == this.fcmToken &&
          other.isDarkMode == this.isDarkMode);
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
  final Value<bool?> isDarkMode;
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
    this.isDarkMode = const Value.absent(),
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
    this.isDarkMode = const Value.absent(),
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
    Expression<bool>? isDarkMode,
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
      if (isDarkMode != null) 'is_dark_mode': isDarkMode,
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
    Value<bool?>? isDarkMode,
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
      isDarkMode: isDarkMode ?? this.isDarkMode,
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
    if (isDarkMode.present) {
      map['is_dark_mode'] = Variable<bool>(isDarkMode.value);
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
          ..write('isDarkMode: $isDarkMode, ')
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

class $PendingActionsTableTable extends PendingActionsTable
    with TableInfo<$PendingActionsTableTable, PendingActionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingActionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    payload,
    retryCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingActionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingActionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingActionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingActionsTableTable createAlias(String alias) {
    return $PendingActionsTableTable(attachedDatabase, alias);
  }
}

class PendingActionsTableData extends DataClass
    implements Insertable<PendingActionsTableData> {
  /// Identifiant unique de l'action (UUID générée localement).
  final String id;

  /// Type d'action : 'create_order' | 'cancel_order' | 'rate_order' | etc.
  final String type;

  /// Payload JSON sérialisé à envoyer.
  final String payload;

  /// Nombre de tentatives d'envoi déjà effectuées.
  final int retryCount;

  /// Date de création de l'action (pour trier / expirer les vieilles actions).
  final DateTime createdAt;
  const PendingActionsTableData({
    required this.id,
    required this.type,
    required this.payload,
    required this.retryCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingActionsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingActionsTableCompanion(
      id: Value(id),
      type: Value(type),
      payload: Value(payload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory PendingActionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingActionsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingActionsTableData copyWith({
    String? id,
    String? type,
    String? payload,
    int? retryCount,
    DateTime? createdAt,
  }) => PendingActionsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    payload: payload ?? this.payload,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingActionsTableData copyWithCompanion(PendingActionsTableCompanion data) {
    return PendingActionsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingActionsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, payload, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingActionsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class PendingActionsTableCompanion
    extends UpdateCompanion<PendingActionsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingActionsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingActionsTableCompanion.insert({
    required String id,
    required String type,
    required String payload,
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       payload = Value(payload);
  static Insertable<PendingActionsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingActionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? payload,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingActionsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingActionsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTableTable extends MenuItemsTable
    with TableInfo<$MenuItemsTableTable, MenuItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _extrasJsonMeta = const VerificationMeta(
    'extrasJson',
  );
  @override
  late final GeneratedColumn<String> extrasJson = GeneratedColumn<String>(
    'extras_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    restaurantId,
    name,
    description,
    price,
    imageUrl,
    category,
    isAvailable,
    extrasJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuItemsTableData> instance, {
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
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('extras_json')) {
      context.handle(
        _extrasJsonMeta,
        extrasJson.isAcceptableOrUnknown(data['extras_json']!, _extrasJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      restaurantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restaurant_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      extrasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extras_json'],
      ),
    );
  }

  @override
  $MenuItemsTableTable createAlias(String alias) {
    return $MenuItemsTableTable(attachedDatabase, alias);
  }
}

class MenuItemsTableData extends DataClass
    implements Insertable<MenuItemsTableData> {
  final String id;
  final String restaurantId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String? category;
  final bool isAvailable;
  final String? extrasJson;
  const MenuItemsTableData({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.category,
    required this.isAvailable,
    this.extrasJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['restaurant_id'] = Variable<String>(restaurantId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    if (!nullToAbsent || extrasJson != null) {
      map['extras_json'] = Variable<String>(extrasJson);
    }
    return map;
  }

  MenuItemsTableCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsTableCompanion(
      id: Value(id),
      restaurantId: Value(restaurantId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isAvailable: Value(isAvailable),
      extrasJson: extrasJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extrasJson),
    );
  }

  factory MenuItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      restaurantId: serializer.fromJson<String>(json['restaurantId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      category: serializer.fromJson<String?>(json['category']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      extrasJson: serializer.fromJson<String?>(json['extrasJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'restaurantId': serializer.toJson<String>(restaurantId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'category': serializer.toJson<String?>(category),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'extrasJson': serializer.toJson<String?>(extrasJson),
    };
  }

  MenuItemsTableData copyWith({
    String? id,
    String? restaurantId,
    String? name,
    Value<String?> description = const Value.absent(),
    double? price,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> category = const Value.absent(),
    bool? isAvailable,
    Value<String?> extrasJson = const Value.absent(),
  }) => MenuItemsTableData(
    id: id ?? this.id,
    restaurantId: restaurantId ?? this.restaurantId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    price: price ?? this.price,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    category: category.present ? category.value : this.category,
    isAvailable: isAvailable ?? this.isAvailable,
    extrasJson: extrasJson.present ? extrasJson.value : this.extrasJson,
  );
  MenuItemsTableData copyWithCompanion(MenuItemsTableCompanion data) {
    return MenuItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      restaurantId: data.restaurantId.present
          ? data.restaurantId.value
          : this.restaurantId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      price: data.price.present ? data.price.value : this.price,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      category: data.category.present ? data.category.value : this.category,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      extrasJson: data.extrasJson.present
          ? data.extrasJson.value
          : this.extrasJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsTableData(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('category: $category, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('extrasJson: $extrasJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    restaurantId,
    name,
    description,
    price,
    imageUrl,
    category,
    isAvailable,
    extrasJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItemsTableData &&
          other.id == this.id &&
          other.restaurantId == this.restaurantId &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.imageUrl == this.imageUrl &&
          other.category == this.category &&
          other.isAvailable == this.isAvailable &&
          other.extrasJson == this.extrasJson);
}

class MenuItemsTableCompanion extends UpdateCompanion<MenuItemsTableData> {
  final Value<String> id;
  final Value<String> restaurantId;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> price;
  final Value<String?> imageUrl;
  final Value<String?> category;
  final Value<bool> isAvailable;
  final Value<String?> extrasJson;
  final Value<int> rowid;
  const MenuItemsTableCompanion({
    this.id = const Value.absent(),
    this.restaurantId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.extrasJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemsTableCompanion.insert({
    required String id,
    required String restaurantId,
    required String name,
    this.description = const Value.absent(),
    required double price,
    this.imageUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.extrasJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       restaurantId = Value(restaurantId),
       name = Value(name),
       price = Value(price);
  static Insertable<MenuItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? restaurantId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<String>? imageUrl,
    Expression<String>? category,
    Expression<bool>? isAvailable,
    Expression<String>? extrasJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (restaurantId != null) 'restaurant_id': restaurantId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (imageUrl != null) 'image_url': imageUrl,
      if (category != null) 'category': category,
      if (isAvailable != null) 'is_available': isAvailable,
      if (extrasJson != null) 'extras_json': extrasJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? restaurantId,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? price,
    Value<String?>? imageUrl,
    Value<String?>? category,
    Value<bool>? isAvailable,
    Value<String?>? extrasJson,
    Value<int>? rowid,
  }) {
    return MenuItemsTableCompanion(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      extrasJson: extrasJson ?? this.extrasJson,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (extrasJson.present) {
      map['extras_json'] = Variable<String>(extrasJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('category: $category, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('extrasJson: $extrasJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTableTable extends ConversationsTable
    with TableInfo<$ConversationsTableTable, ConversationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _participantNameMeta = const VerificationMeta(
    'participantName',
  );
  @override
  late final GeneratedColumn<String> participantName = GeneratedColumn<String>(
    'participant_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _participantAvatarMeta = const VerificationMeta(
    'participantAvatar',
  );
  @override
  late final GeneratedColumn<String> participantAvatar =
      GeneratedColumn<String>(
        'participant_avatar',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMessageContentMeta =
      const VerificationMeta('lastMessageContent');
  @override
  late final GeneratedColumn<String> lastMessageContent =
      GeneratedColumn<String>(
        'last_message_content',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    participantName,
    participantAvatar,
    lastMessageContent,
    lastMessageAt,
    unreadCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('participant_name')) {
      context.handle(
        _participantNameMeta,
        participantName.isAcceptableOrUnknown(
          data['participant_name']!,
          _participantNameMeta,
        ),
      );
    }
    if (data.containsKey('participant_avatar')) {
      context.handle(
        _participantAvatarMeta,
        participantAvatar.isAcceptableOrUnknown(
          data['participant_avatar']!,
          _participantAvatarMeta,
        ),
      );
    }
    if (data.containsKey('last_message_content')) {
      context.handle(
        _lastMessageContentMeta,
        lastMessageContent.isAcceptableOrUnknown(
          data['last_message_content']!,
          _lastMessageContentMeta,
        ),
      );
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      participantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participant_name'],
      ),
      participantAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participant_avatar'],
      ),
      lastMessageContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message_content'],
      ),
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ConversationsTableTable createAlias(String alias) {
    return $ConversationsTableTable(attachedDatabase, alias);
  }
}

class ConversationsTableData extends DataClass
    implements Insertable<ConversationsTableData> {
  final String id;
  final String type;
  final String? participantName;
  final String? participantAvatar;
  final String? lastMessageContent;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime updatedAt;
  const ConversationsTableData({
    required this.id,
    required this.type,
    this.participantName,
    this.participantAvatar,
    this.lastMessageContent,
    this.lastMessageAt,
    required this.unreadCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || participantName != null) {
      map['participant_name'] = Variable<String>(participantName);
    }
    if (!nullToAbsent || participantAvatar != null) {
      map['participant_avatar'] = Variable<String>(participantAvatar);
    }
    if (!nullToAbsent || lastMessageContent != null) {
      map['last_message_content'] = Variable<String>(lastMessageContent);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationsTableCompanion(
      id: Value(id),
      type: Value(type),
      participantName: participantName == null && nullToAbsent
          ? const Value.absent()
          : Value(participantName),
      participantAvatar: participantAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(participantAvatar),
      lastMessageContent: lastMessageContent == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageContent),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      unreadCount: Value(unreadCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory ConversationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      participantName: serializer.fromJson<String?>(json['participantName']),
      participantAvatar: serializer.fromJson<String?>(
        json['participantAvatar'],
      ),
      lastMessageContent: serializer.fromJson<String?>(
        json['lastMessageContent'],
      ),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'participantName': serializer.toJson<String?>(participantName),
      'participantAvatar': serializer.toJson<String?>(participantAvatar),
      'lastMessageContent': serializer.toJson<String?>(lastMessageContent),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ConversationsTableData copyWith({
    String? id,
    String? type,
    Value<String?> participantName = const Value.absent(),
    Value<String?> participantAvatar = const Value.absent(),
    Value<String?> lastMessageContent = const Value.absent(),
    Value<DateTime?> lastMessageAt = const Value.absent(),
    int? unreadCount,
    DateTime? updatedAt,
  }) => ConversationsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    participantName: participantName.present
        ? participantName.value
        : this.participantName,
    participantAvatar: participantAvatar.present
        ? participantAvatar.value
        : this.participantAvatar,
    lastMessageContent: lastMessageContent.present
        ? lastMessageContent.value
        : this.lastMessageContent,
    lastMessageAt: lastMessageAt.present
        ? lastMessageAt.value
        : this.lastMessageAt,
    unreadCount: unreadCount ?? this.unreadCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ConversationsTableData copyWithCompanion(ConversationsTableCompanion data) {
    return ConversationsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      participantName: data.participantName.present
          ? data.participantName.value
          : this.participantName,
      participantAvatar: data.participantAvatar.present
          ? data.participantAvatar.value
          : this.participantAvatar,
      lastMessageContent: data.lastMessageContent.present
          ? data.lastMessageContent.value
          : this.lastMessageContent,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('participantName: $participantName, ')
          ..write('participantAvatar: $participantAvatar, ')
          ..write('lastMessageContent: $lastMessageContent, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    participantName,
    participantAvatar,
    lastMessageContent,
    lastMessageAt,
    unreadCount,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.participantName == this.participantName &&
          other.participantAvatar == this.participantAvatar &&
          other.lastMessageContent == this.lastMessageContent &&
          other.lastMessageAt == this.lastMessageAt &&
          other.unreadCount == this.unreadCount &&
          other.updatedAt == this.updatedAt);
}

class ConversationsTableCompanion
    extends UpdateCompanion<ConversationsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String?> participantName;
  final Value<String?> participantAvatar;
  final Value<String?> lastMessageContent;
  final Value<DateTime?> lastMessageAt;
  final Value<int> unreadCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConversationsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.participantName = const Value.absent(),
    this.participantAvatar = const Value.absent(),
    this.lastMessageContent = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsTableCompanion.insert({
    required String id,
    required String type,
    this.participantName = const Value.absent(),
    this.participantAvatar = const Value.absent(),
    this.lastMessageContent = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type);
  static Insertable<ConversationsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? participantName,
    Expression<String>? participantAvatar,
    Expression<String>? lastMessageContent,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? unreadCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (participantName != null) 'participant_name': participantName,
      if (participantAvatar != null) 'participant_avatar': participantAvatar,
      if (lastMessageContent != null)
        'last_message_content': lastMessageContent,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String?>? participantName,
    Value<String?>? participantAvatar,
    Value<String?>? lastMessageContent,
    Value<DateTime?>? lastMessageAt,
    Value<int>? unreadCount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConversationsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (participantName.present) {
      map['participant_name'] = Variable<String>(participantName.value);
    }
    if (participantAvatar.present) {
      map['participant_avatar'] = Variable<String>(participantAvatar.value);
    }
    if (lastMessageContent.present) {
      map['last_message_content'] = Variable<String>(lastMessageContent.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('participantName: $participantName, ')
          ..write('participantAvatar: $participantAvatar, ')
          ..write('lastMessageContent: $lastMessageContent, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTableTable extends MessagesTable
    with TableInfo<$MessagesTableTable, MessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderRoleMeta = const VerificationMeta(
    'senderRole',
  );
  @override
  late final GeneratedColumn<String> senderRole = GeneratedColumn<String>(
    'sender_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileUrlMeta = const VerificationMeta(
    'fileUrl',
  );
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
    'file_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageTypeMeta = const VerificationMeta(
    'messageType',
  );
  @override
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
    'message_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sent'),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    senderId,
    senderRole,
    content,
    fileUrl,
    messageType,
    status,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_role')) {
      context.handle(
        _senderRoleMeta,
        senderRole.isAcceptableOrUnknown(data['sender_role']!, _senderRoleMeta),
      );
    } else if (isInserting) {
      context.missing(_senderRoleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(
        _fileUrlMeta,
        fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta),
      );
    }
    if (data.containsKey('message_type')) {
      context.handle(
        _messageTypeMeta,
        messageType.isAcceptableOrUnknown(
          data['message_type']!,
          _messageTypeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      senderRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      fileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_url'],
      ),
      messageType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessagesTableTable createAlias(String alias) {
    return $MessagesTableTable(attachedDatabase, alias);
  }
}

class MessagesTableData extends DataClass
    implements Insertable<MessagesTableData> {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderRole;
  final String content;
  final String? fileUrl;
  final String messageType;
  final String status;
  final bool isRead;
  final DateTime createdAt;
  const MessagesTableData({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.content,
    this.fileUrl,
    required this.messageType,
    required this.status,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_id'] = Variable<String>(senderId);
    map['sender_role'] = Variable<String>(senderRole);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    map['message_type'] = Variable<String>(messageType);
    map['status'] = Variable<String>(status);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessagesTableCompanion toCompanion(bool nullToAbsent) {
    return MessagesTableCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      senderId: Value(senderId),
      senderRole: Value(senderRole),
      content: Value(content),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      messageType: Value(messageType),
      status: Value(status),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory MessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderRole: serializer.fromJson<String>(json['senderRole']),
      content: serializer.fromJson<String>(json['content']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      messageType: serializer.fromJson<String>(json['messageType']),
      status: serializer.fromJson<String>(json['status']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderId': serializer.toJson<String>(senderId),
      'senderRole': serializer.toJson<String>(senderRole),
      'content': serializer.toJson<String>(content),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'messageType': serializer.toJson<String>(messageType),
      'status': serializer.toJson<String>(status),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MessagesTableData copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderRole,
    String? content,
    Value<String?> fileUrl = const Value.absent(),
    String? messageType,
    String? status,
    bool? isRead,
    DateTime? createdAt,
  }) => MessagesTableData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    senderRole: senderRole ?? this.senderRole,
    content: content ?? this.content,
    fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
    messageType: messageType ?? this.messageType,
    status: status ?? this.status,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  MessagesTableData copyWithCompanion(MessagesTableCompanion data) {
    return MessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderRole: data.senderRole.present
          ? data.senderRole.value
          : this.senderRole,
      content: data.content.present ? data.content.value : this.content,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      messageType: data.messageType.present
          ? data.messageType.value
          : this.messageType,
      status: data.status.present ? data.status.value : this.status,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('senderRole: $senderRole, ')
          ..write('content: $content, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('messageType: $messageType, ')
          ..write('status: $status, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    senderId,
    senderRole,
    content,
    fileUrl,
    messageType,
    status,
    isRead,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesTableData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.senderId == this.senderId &&
          other.senderRole == this.senderRole &&
          other.content == this.content &&
          other.fileUrl == this.fileUrl &&
          other.messageType == this.messageType &&
          other.status == this.status &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class MessagesTableCompanion extends UpdateCompanion<MessagesTableData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> senderId;
  final Value<String> senderRole;
  final Value<String> content;
  final Value<String?> fileUrl;
  final Value<String> messageType;
  final Value<String> status;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessagesTableCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderRole = const Value.absent(),
    this.content = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.messageType = const Value.absent(),
    this.status = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesTableCompanion.insert({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderRole,
    required String content,
    this.fileUrl = const Value.absent(),
    this.messageType = const Value.absent(),
    this.status = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       senderId = Value(senderId),
       senderRole = Value(senderRole),
       content = Value(content);
  static Insertable<MessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? senderId,
    Expression<String>? senderRole,
    Expression<String>? content,
    Expression<String>? fileUrl,
    Expression<String>? messageType,
    Expression<String>? status,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderId != null) 'sender_id': senderId,
      if (senderRole != null) 'sender_role': senderRole,
      if (content != null) 'content': content,
      if (fileUrl != null) 'file_url': fileUrl,
      if (messageType != null) 'message_type': messageType,
      if (status != null) 'status': status,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? senderId,
    Value<String>? senderRole,
    Value<String>? content,
    Value<String?>? fileUrl,
    Value<String>? messageType,
    Value<String>? status,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MessagesTableCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderRole: senderRole ?? this.senderRole,
      content: content ?? this.content,
      fileUrl: fileUrl ?? this.fileUrl,
      messageType: messageType ?? this.messageType,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderRole.present) {
      map['sender_role'] = Variable<String>(senderRole.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('senderRole: $senderRole, ')
          ..write('content: $content, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('messageType: $messageType, ')
          ..write('status: $status, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restaurantNameMeta = const VerificationMeta(
    'restaurantName',
  );
  @override
  late final GeneratedColumn<String> restaurantName = GeneratedColumn<String>(
    'restaurant_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryFeeMeta = const VerificationMeta(
    'deliveryFee',
  );
  @override
  late final GeneratedColumn<double> deliveryFee = GeneratedColumn<double>(
    'delivery_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryAddressJsonMeta =
      const VerificationMeta('deliveryAddressJson');
  @override
  late final GeneratedColumn<String> deliveryAddressJson =
      GeneratedColumn<String>(
        'delivery_address_json',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    restaurantId,
    restaurantName,
    itemsJson,
    total,
    deliveryFee,
    status,
    paymentMethod,
    deliveryAddressJson,
    notes,
    createdAt,
    rating,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdersTableData> instance, {
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
    }
    if (data.containsKey('restaurant_name')) {
      context.handle(
        _restaurantNameMeta,
        restaurantName.isAcceptableOrUnknown(
          data['restaurant_name']!,
          _restaurantNameMeta,
        ),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('delivery_address_json')) {
      context.handle(
        _deliveryAddressJsonMeta,
        deliveryAddressJson.isAcceptableOrUnknown(
          data['delivery_address_json']!,
          _deliveryAddressJsonMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      restaurantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restaurant_id'],
      ),
      restaurantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restaurant_name'],
      ),
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      deliveryFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_fee'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      deliveryAddressJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_address_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final String itemsJson;
  final double total;
  final double? deliveryFee;
  final String status;
  final String? paymentMethod;
  final String? deliveryAddressJson;
  final String? notes;
  final DateTime? createdAt;
  final double? rating;
  const OrdersTableData({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    required this.itemsJson,
    required this.total,
    this.deliveryFee,
    required this.status,
    this.paymentMethod,
    this.deliveryAddressJson,
    this.notes,
    this.createdAt,
    this.rating,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || restaurantId != null) {
      map['restaurant_id'] = Variable<String>(restaurantId);
    }
    if (!nullToAbsent || restaurantName != null) {
      map['restaurant_name'] = Variable<String>(restaurantName);
    }
    map['items_json'] = Variable<String>(itemsJson);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || deliveryFee != null) {
      map['delivery_fee'] = Variable<double>(deliveryFee);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || deliveryAddressJson != null) {
      map['delivery_address_json'] = Variable<String>(deliveryAddressJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      restaurantId: restaurantId == null && nullToAbsent
          ? const Value.absent()
          : Value(restaurantId),
      restaurantName: restaurantName == null && nullToAbsent
          ? const Value.absent()
          : Value(restaurantName),
      itemsJson: Value(itemsJson),
      total: Value(total),
      deliveryFee: deliveryFee == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryFee),
      status: Value(status),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      deliveryAddressJson: deliveryAddressJson == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAddressJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
    );
  }

  factory OrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      restaurantId: serializer.fromJson<String?>(json['restaurantId']),
      restaurantName: serializer.fromJson<String?>(json['restaurantName']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      total: serializer.fromJson<double>(json['total']),
      deliveryFee: serializer.fromJson<double?>(json['deliveryFee']),
      status: serializer.fromJson<String>(json['status']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      deliveryAddressJson: serializer.fromJson<String?>(
        json['deliveryAddressJson'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      rating: serializer.fromJson<double?>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'restaurantId': serializer.toJson<String?>(restaurantId),
      'restaurantName': serializer.toJson<String?>(restaurantName),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'total': serializer.toJson<double>(total),
      'deliveryFee': serializer.toJson<double?>(deliveryFee),
      'status': serializer.toJson<String>(status),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'deliveryAddressJson': serializer.toJson<String?>(deliveryAddressJson),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'rating': serializer.toJson<double?>(rating),
    };
  }

  OrdersTableData copyWith({
    String? id,
    Value<String?> restaurantId = const Value.absent(),
    Value<String?> restaurantName = const Value.absent(),
    String? itemsJson,
    double? total,
    Value<double?> deliveryFee = const Value.absent(),
    String? status,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> deliveryAddressJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<double?> rating = const Value.absent(),
  }) => OrdersTableData(
    id: id ?? this.id,
    restaurantId: restaurantId.present ? restaurantId.value : this.restaurantId,
    restaurantName: restaurantName.present
        ? restaurantName.value
        : this.restaurantName,
    itemsJson: itemsJson ?? this.itemsJson,
    total: total ?? this.total,
    deliveryFee: deliveryFee.present ? deliveryFee.value : this.deliveryFee,
    status: status ?? this.status,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    deliveryAddressJson: deliveryAddressJson.present
        ? deliveryAddressJson.value
        : this.deliveryAddressJson,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    rating: rating.present ? rating.value : this.rating,
  );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      restaurantId: data.restaurantId.present
          ? data.restaurantId.value
          : this.restaurantId,
      restaurantName: data.restaurantName.present
          ? data.restaurantName.value
          : this.restaurantName,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      total: data.total.present ? data.total.value : this.total,
      deliveryFee: data.deliveryFee.present
          ? data.deliveryFee.value
          : this.deliveryFee,
      status: data.status.present ? data.status.value : this.status,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      deliveryAddressJson: data.deliveryAddressJson.present
          ? data.deliveryAddressJson.value
          : this.deliveryAddressJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      rating: data.rating.present ? data.rating.value : this.rating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('restaurantName: $restaurantName, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('total: $total, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('deliveryAddressJson: $deliveryAddressJson, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    restaurantId,
    restaurantName,
    itemsJson,
    total,
    deliveryFee,
    status,
    paymentMethod,
    deliveryAddressJson,
    notes,
    createdAt,
    rating,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.restaurantId == this.restaurantId &&
          other.restaurantName == this.restaurantName &&
          other.itemsJson == this.itemsJson &&
          other.total == this.total &&
          other.deliveryFee == this.deliveryFee &&
          other.status == this.status &&
          other.paymentMethod == this.paymentMethod &&
          other.deliveryAddressJson == this.deliveryAddressJson &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.rating == this.rating);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<String> id;
  final Value<String?> restaurantId;
  final Value<String?> restaurantName;
  final Value<String> itemsJson;
  final Value<double> total;
  final Value<double?> deliveryFee;
  final Value<String> status;
  final Value<String?> paymentMethod;
  final Value<String?> deliveryAddressJson;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<double?> rating;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.restaurantId = const Value.absent(),
    this.restaurantName = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.total = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.deliveryAddressJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    required String id,
    this.restaurantId = const Value.absent(),
    this.restaurantName = const Value.absent(),
    required String itemsJson,
    required double total,
    this.deliveryFee = const Value.absent(),
    required String status,
    this.paymentMethod = const Value.absent(),
    this.deliveryAddressJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemsJson = Value(itemsJson),
       total = Value(total),
       status = Value(status);
  static Insertable<OrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? restaurantId,
    Expression<String>? restaurantName,
    Expression<String>? itemsJson,
    Expression<double>? total,
    Expression<double>? deliveryFee,
    Expression<String>? status,
    Expression<String>? paymentMethod,
    Expression<String>? deliveryAddressJson,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<double>? rating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (restaurantId != null) 'restaurant_id': restaurantId,
      if (restaurantName != null) 'restaurant_name': restaurantName,
      if (itemsJson != null) 'items_json': itemsJson,
      if (total != null) 'total': total,
      if (deliveryFee != null) 'delivery_fee': deliveryFee,
      if (status != null) 'status': status,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (deliveryAddressJson != null)
        'delivery_address_json': deliveryAddressJson,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? restaurantId,
    Value<String?>? restaurantName,
    Value<String>? itemsJson,
    Value<double>? total,
    Value<double?>? deliveryFee,
    Value<String>? status,
    Value<String?>? paymentMethod,
    Value<String?>? deliveryAddressJson,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<double?>? rating,
    Value<int>? rowid,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      itemsJson: itemsJson ?? this.itemsJson,
      total: total ?? this.total,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddressJson: deliveryAddressJson ?? this.deliveryAddressJson,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
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
    if (restaurantName.present) {
      map['restaurant_name'] = Variable<String>(restaurantName.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (deliveryFee.present) {
      map['delivery_fee'] = Variable<double>(deliveryFee.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (deliveryAddressJson.present) {
      map['delivery_address_json'] = Variable<String>(
        deliveryAddressJson.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('restaurantId: $restaurantId, ')
          ..write('restaurantName: $restaurantName, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('total: $total, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('deliveryAddressJson: $deliveryAddressJson, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTableTable extends FavoritesTable
    with TableInfo<$FavoritesTableTable, FavoritesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [restaurantId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoritesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {restaurantId};
  @override
  FavoritesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritesTableData(
      restaurantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restaurant_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $FavoritesTableTable createAlias(String alias) {
    return $FavoritesTableTable(attachedDatabase, alias);
  }
}

class FavoritesTableData extends DataClass
    implements Insertable<FavoritesTableData> {
  /// Restaurant ID (backend _id).
  final String restaurantId;

  /// When the favorite was added locally.
  final DateTime savedAt;
  const FavoritesTableData({required this.restaurantId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['restaurant_id'] = Variable<String>(restaurantId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  FavoritesTableCompanion toCompanion(bool nullToAbsent) {
    return FavoritesTableCompanion(
      restaurantId: Value(restaurantId),
      savedAt: Value(savedAt),
    );
  }

  factory FavoritesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritesTableData(
      restaurantId: serializer.fromJson<String>(json['restaurantId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'restaurantId': serializer.toJson<String>(restaurantId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  FavoritesTableData copyWith({String? restaurantId, DateTime? savedAt}) =>
      FavoritesTableData(
        restaurantId: restaurantId ?? this.restaurantId,
        savedAt: savedAt ?? this.savedAt,
      );
  FavoritesTableData copyWithCompanion(FavoritesTableCompanion data) {
    return FavoritesTableData(
      restaurantId: data.restaurantId.present
          ? data.restaurantId.value
          : this.restaurantId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableData(')
          ..write('restaurantId: $restaurantId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(restaurantId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritesTableData &&
          other.restaurantId == this.restaurantId &&
          other.savedAt == this.savedAt);
}

class FavoritesTableCompanion extends UpdateCompanion<FavoritesTableData> {
  final Value<String> restaurantId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const FavoritesTableCompanion({
    this.restaurantId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesTableCompanion.insert({
    required String restaurantId,
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : restaurantId = Value(restaurantId);
  static Insertable<FavoritesTableData> custom({
    Expression<String>? restaurantId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (restaurantId != null) 'restaurant_id': restaurantId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesTableCompanion copyWith({
    Value<String>? restaurantId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return FavoritesTableCompanion(
      restaurantId: restaurantId ?? this.restaurantId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (restaurantId.present) {
      map['restaurant_id'] = Variable<String>(restaurantId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableCompanion(')
          ..write('restaurantId: $restaurantId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineActionsTableTable extends OfflineActionsTable
    with TableInfo<$OfflineActionsTableTable, OfflineActionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineActionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxRetriesMeta = const VerificationMeta(
    'maxRetries',
  );
  @override
  late final GeneratedColumn<int> maxRetries = GeneratedColumn<int>(
    'max_retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actionType,
    payload,
    retryCount,
    maxRetries,
    createdAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineActionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('max_retries')) {
      context.handle(
        _maxRetriesMeta,
        maxRetries.isAcceptableOrUnknown(data['max_retries']!, _maxRetriesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineActionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineActionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      maxRetries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_retries'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $OfflineActionsTableTable createAlias(String alias) {
    return $OfflineActionsTableTable(attachedDatabase, alias);
  }
}

class OfflineActionsTableData extends DataClass
    implements Insertable<OfflineActionsTableData> {
  final int id;

  /// Type d'action — identifie le handler dans SyncManagerService.
  final String actionType;

  /// Payload JSON sérialisé contenant les données de l'action.
  final String payload;

  /// Nombre de tentatives déjà effectuées.
  final int retryCount;

  /// Nombre maximum de tentatives avant marquage 'failed'.
  final int maxRetries;

  /// Date de création de l'entrée.
  final DateTime createdAt;

  /// Statut de l'action : 'pending' | 'processing' | 'failed'.
  final String status;
  const OfflineActionsTableData({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.retryCount,
    required this.maxRetries,
    required this.createdAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action_type'] = Variable<String>(actionType);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['max_retries'] = Variable<int>(maxRetries);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  OfflineActionsTableCompanion toCompanion(bool nullToAbsent) {
    return OfflineActionsTableCompanion(
      id: Value(id),
      actionType: Value(actionType),
      payload: Value(payload),
      retryCount: Value(retryCount),
      maxRetries: Value(maxRetries),
      createdAt: Value(createdAt),
      status: Value(status),
    );
  }

  factory OfflineActionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineActionsTableData(
      id: serializer.fromJson<int>(json['id']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      maxRetries: serializer.fromJson<int>(json['maxRetries']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actionType': serializer.toJson<String>(actionType),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'maxRetries': serializer.toJson<int>(maxRetries),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
    };
  }

  OfflineActionsTableData copyWith({
    int? id,
    String? actionType,
    String? payload,
    int? retryCount,
    int? maxRetries,
    DateTime? createdAt,
    String? status,
  }) => OfflineActionsTableData(
    id: id ?? this.id,
    actionType: actionType ?? this.actionType,
    payload: payload ?? this.payload,
    retryCount: retryCount ?? this.retryCount,
    maxRetries: maxRetries ?? this.maxRetries,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
  );
  OfflineActionsTableData copyWithCompanion(OfflineActionsTableCompanion data) {
    return OfflineActionsTableData(
      id: data.id.present ? data.id.value : this.id,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      maxRetries: data.maxRetries.present
          ? data.maxRetries.value
          : this.maxRetries,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineActionsTableData(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actionType,
    payload,
    retryCount,
    maxRetries,
    createdAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineActionsTableData &&
          other.id == this.id &&
          other.actionType == this.actionType &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.maxRetries == this.maxRetries &&
          other.createdAt == this.createdAt &&
          other.status == this.status);
}

class OfflineActionsTableCompanion
    extends UpdateCompanion<OfflineActionsTableData> {
  final Value<int> id;
  final Value<String> actionType;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<int> maxRetries;
  final Value<DateTime> createdAt;
  final Value<String> status;
  const OfflineActionsTableCompanion({
    this.id = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  OfflineActionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String actionType,
    required String payload,
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
  }) : actionType = Value(actionType),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OfflineActionsTableData> custom({
    Expression<int>? id,
    Expression<String>? actionType,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<int>? maxRetries,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionType != null) 'action_type': actionType,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (maxRetries != null) 'max_retries': maxRetries,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
    });
  }

  OfflineActionsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? actionType,
    Value<String>? payload,
    Value<int>? retryCount,
    Value<int>? maxRetries,
    Value<DateTime>? createdAt,
    Value<String>? status,
  }) {
    return OfflineActionsTableCompanion(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (maxRetries.present) {
      map['max_retries'] = Variable<int>(maxRetries.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineActionsTableCompanion(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $AiConversationsTableTable extends AiConversationsTable
    with TableInfo<$AiConversationsTableTable, AiConversationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiConversationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Nouvelle conversation'),
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    title,
    lastMessageAt,
    createdAt,
    isSynced,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_conversations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiConversationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastMessageAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiConversationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiConversationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $AiConversationsTableTable createAlias(String alias) {
    return $AiConversationsTableTable(attachedDatabase, alias);
  }
}

class AiConversationsTableData extends DataClass
    implements Insertable<AiConversationsTableData> {
  final String id;
  final String? serverId;
  final String title;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final bool isSynced;
  final bool isArchived;
  const AiConversationsTableData({
    required this.id,
    this.serverId,
    required this.title,
    required this.lastMessageAt,
    required this.createdAt,
    required this.isSynced,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['title'] = Variable<String>(title);
    map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AiConversationsTableCompanion toCompanion(bool nullToAbsent) {
    return AiConversationsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      title: Value(title),
      lastMessageAt: Value(lastMessageAt),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      isArchived: Value(isArchived),
    );
  }

  factory AiConversationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiConversationsTableData(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      title: serializer.fromJson<String>(json['title']),
      lastMessageAt: serializer.fromJson<DateTime>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'title': serializer.toJson<String>(title),
      'lastMessageAt': serializer.toJson<DateTime>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  AiConversationsTableData copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? title,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    bool? isSynced,
    bool? isArchived,
  }) => AiConversationsTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    title: title ?? this.title,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    isArchived: isArchived ?? this.isArchived,
  );
  AiConversationsTableData copyWithCompanion(
    AiConversationsTableCompanion data,
  ) {
    return AiConversationsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      title: data.title.present ? data.title.value : this.title,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('title: $title, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    title,
    lastMessageAt,
    createdAt,
    isSynced,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiConversationsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.title == this.title &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.isArchived == this.isArchived);
}

class AiConversationsTableCompanion
    extends UpdateCompanion<AiConversationsTableData> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> title;
  final Value<DateTime> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AiConversationsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.title = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiConversationsTableCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    this.title = const Value.absent(),
    required DateTime lastMessageAt,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lastMessageAt = Value(lastMessageAt),
       createdAt = Value(createdAt);
  static Insertable<AiConversationsTableData> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? title,
    Expression<DateTime>? lastMessageAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (title != null) 'title': title,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiConversationsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? title,
    Value<DateTime>? lastMessageAt,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return AiConversationsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('title: $title, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiMessagesTableTable extends AiMessagesTable
    with TableInfo<$AiMessagesTableTable, AiMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ai_conversations_table (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenCountMeta = const VerificationMeta(
    'tokenCount',
  );
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
    'token_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    content,
    tokenCount,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('token_count')) {
      context.handle(
        _tokenCountMeta,
        tokenCount.isAcceptableOrUnknown(data['token_count']!, _tokenCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      tokenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_count'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $AiMessagesTableTable createAlias(String alias) {
    return $AiMessagesTableTable(attachedDatabase, alias);
  }
}

class AiMessagesTableData extends DataClass
    implements Insertable<AiMessagesTableData> {
  final int id;
  final String conversationId;
  final String role;
  final String content;
  final int? tokenCount;
  final DateTime createdAt;
  final bool isSynced;
  const AiMessagesTableData({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.tokenCount,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || tokenCount != null) {
      map['token_count'] = Variable<int>(tokenCount);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  AiMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return AiMessagesTableCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      tokenCount: tokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenCount),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory AiMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMessagesTableData(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      tokenCount: serializer.fromJson<int?>(json['tokenCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'tokenCount': serializer.toJson<int?>(tokenCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  AiMessagesTableData copyWith({
    int? id,
    String? conversationId,
    String? role,
    String? content,
    Value<int?> tokenCount = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => AiMessagesTableData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    content: content ?? this.content,
    tokenCount: tokenCount.present ? tokenCount.value : this.tokenCount,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  AiMessagesTableData copyWithCompanion(AiMessagesTableCompanion data) {
    return AiMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      tokenCount: data.tokenCount.present
          ? data.tokenCount.value
          : this.tokenCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMessagesTableData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    role,
    content,
    tokenCount,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMessagesTableData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.content == this.content &&
          other.tokenCount == this.tokenCount &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class AiMessagesTableCompanion extends UpdateCompanion<AiMessagesTableData> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> content;
  final Value<int?> tokenCount;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const AiMessagesTableCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  AiMessagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required String role,
    required String content,
    this.tokenCount = const Value.absent(),
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
  }) : conversationId = Value(conversationId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<AiMessagesTableData> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<int>? tokenCount,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (tokenCount != null) 'token_count': tokenCount,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  AiMessagesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? content,
    Value<int?>? tokenCount,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return AiMessagesTableCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      tokenCount: tokenCount ?? this.tokenCount,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
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
  late final $PendingActionsTableTable pendingActionsTable =
      $PendingActionsTableTable(this);
  late final $MenuItemsTableTable menuItemsTable = $MenuItemsTableTable(this);
  late final $ConversationsTableTable conversationsTable =
      $ConversationsTableTable(this);
  late final $MessagesTableTable messagesTable = $MessagesTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $FavoritesTableTable favoritesTable = $FavoritesTableTable(this);
  late final $OfflineActionsTableTable offlineActionsTable =
      $OfflineActionsTableTable(this);
  late final $AiConversationsTableTable aiConversationsTable =
      $AiConversationsTableTable(this);
  late final $AiMessagesTableTable aiMessagesTable = $AiMessagesTableTable(
    this,
  );
  late final MenuDao menuDao = MenuDao(this as AppDatabase);
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final PendingActionsDao pendingActionsDao = PendingActionsDao(
    this as AppDatabase,
  );
  late final OrderDao orderDao = OrderDao(this as AppDatabase);
  late final OfflineQueueDao offlineQueueDao = OfflineQueueDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userPrefsTable,
    restaurantsTable,
    cartTable,
    pendingActionsTable,
    menuItemsTable,
    conversationsTable,
    messagesTable,
    ordersTable,
    favoritesTable,
    offlineActionsTable,
    aiConversationsTable,
    aiMessagesTable,
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
      Value<bool?> isDarkMode,
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
      Value<bool?> isDarkMode,
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

  ColumnFilters<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
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

  ColumnOrderings<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
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

  GeneratedColumn<bool> get isDarkMode => $composableBuilder(
    column: $table.isDarkMode,
    builder: (column) => column,
  );
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
                Value<bool?> isDarkMode = const Value.absent(),
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
                isDarkMode: isDarkMode,
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
                Value<bool?> isDarkMode = const Value.absent(),
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
                isDarkMode: isDarkMode,
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
typedef $$PendingActionsTableTableCreateCompanionBuilder =
    PendingActionsTableCompanion Function({
      required String id,
      required String type,
      required String payload,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingActionsTableTableUpdateCompanionBuilder =
    PendingActionsTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> payload,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingActionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingActionsTableTable> {
  $$PendingActionsTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingActionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingActionsTableTable> {
  $$PendingActionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingActionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingActionsTableTable> {
  $$PendingActionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingActionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingActionsTableTable,
          PendingActionsTableData,
          $$PendingActionsTableTableFilterComposer,
          $$PendingActionsTableTableOrderingComposer,
          $$PendingActionsTableTableAnnotationComposer,
          $$PendingActionsTableTableCreateCompanionBuilder,
          $$PendingActionsTableTableUpdateCompanionBuilder,
          (
            PendingActionsTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingActionsTableTable,
              PendingActionsTableData
            >,
          ),
          PendingActionsTableData,
          PrefetchHooks Function()
        > {
  $$PendingActionsTableTableTableManager(
    _$AppDatabase db,
    $PendingActionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingActionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingActionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingActionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingActionsTableCompanion(
                id: id,
                type: type,
                payload: payload,
                retryCount: retryCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String payload,
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingActionsTableCompanion.insert(
                id: id,
                type: type,
                payload: payload,
                retryCount: retryCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingActionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingActionsTableTable,
      PendingActionsTableData,
      $$PendingActionsTableTableFilterComposer,
      $$PendingActionsTableTableOrderingComposer,
      $$PendingActionsTableTableAnnotationComposer,
      $$PendingActionsTableTableCreateCompanionBuilder,
      $$PendingActionsTableTableUpdateCompanionBuilder,
      (
        PendingActionsTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingActionsTableTable,
          PendingActionsTableData
        >,
      ),
      PendingActionsTableData,
      PrefetchHooks Function()
    >;
typedef $$MenuItemsTableTableCreateCompanionBuilder =
    MenuItemsTableCompanion Function({
      required String id,
      required String restaurantId,
      required String name,
      Value<String?> description,
      required double price,
      Value<String?> imageUrl,
      Value<String?> category,
      Value<bool> isAvailable,
      Value<String?> extrasJson,
      Value<int> rowid,
    });
typedef $$MenuItemsTableTableUpdateCompanionBuilder =
    MenuItemsTableCompanion Function({
      Value<String> id,
      Value<String> restaurantId,
      Value<String> name,
      Value<String?> description,
      Value<double> price,
      Value<String?> imageUrl,
      Value<String?> category,
      Value<bool> isAvailable,
      Value<String?> extrasJson,
      Value<int> rowid,
    });

class $$MenuItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemsTableTable> {
  $$MenuItemsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extrasJson => $composableBuilder(
    column: $table.extrasJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemsTableTable> {
  $$MenuItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extrasJson => $composableBuilder(
    column: $table.extrasJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemsTableTable> {
  $$MenuItemsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extrasJson => $composableBuilder(
    column: $table.extrasJson,
    builder: (column) => column,
  );
}

class $$MenuItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MenuItemsTableTable,
          MenuItemsTableData,
          $$MenuItemsTableTableFilterComposer,
          $$MenuItemsTableTableOrderingComposer,
          $$MenuItemsTableTableAnnotationComposer,
          $$MenuItemsTableTableCreateCompanionBuilder,
          $$MenuItemsTableTableUpdateCompanionBuilder,
          (
            MenuItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $MenuItemsTableTable,
              MenuItemsTableData
            >,
          ),
          MenuItemsTableData,
          PrefetchHooks Function()
        > {
  $$MenuItemsTableTableTableManager(
    _$AppDatabase db,
    $MenuItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> restaurantId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<String?> extrasJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemsTableCompanion(
                id: id,
                restaurantId: restaurantId,
                name: name,
                description: description,
                price: price,
                imageUrl: imageUrl,
                category: category,
                isAvailable: isAvailable,
                extrasJson: extrasJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String restaurantId,
                required String name,
                Value<String?> description = const Value.absent(),
                required double price,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<String?> extrasJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemsTableCompanion.insert(
                id: id,
                restaurantId: restaurantId,
                name: name,
                description: description,
                price: price,
                imageUrl: imageUrl,
                category: category,
                isAvailable: isAvailable,
                extrasJson: extrasJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MenuItemsTableTable,
      MenuItemsTableData,
      $$MenuItemsTableTableFilterComposer,
      $$MenuItemsTableTableOrderingComposer,
      $$MenuItemsTableTableAnnotationComposer,
      $$MenuItemsTableTableCreateCompanionBuilder,
      $$MenuItemsTableTableUpdateCompanionBuilder,
      (
        MenuItemsTableData,
        BaseReferences<_$AppDatabase, $MenuItemsTableTable, MenuItemsTableData>,
      ),
      MenuItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$ConversationsTableTableCreateCompanionBuilder =
    ConversationsTableCompanion Function({
      required String id,
      required String type,
      Value<String?> participantName,
      Value<String?> participantAvatar,
      Value<String?> lastMessageContent,
      Value<DateTime?> lastMessageAt,
      Value<int> unreadCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ConversationsTableTableUpdateCompanionBuilder =
    ConversationsTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String?> participantName,
      Value<String?> participantAvatar,
      Value<String?> lastMessageContent,
      Value<DateTime?> lastMessageAt,
      Value<int> unreadCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ConversationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participantName => $composableBuilder(
    column: $table.participantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participantAvatar => $composableBuilder(
    column: $table.participantAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessageContent => $composableBuilder(
    column: $table.lastMessageContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participantName => $composableBuilder(
    column: $table.participantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participantAvatar => $composableBuilder(
    column: $table.participantAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessageContent => $composableBuilder(
    column: $table.lastMessageContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get participantName => $composableBuilder(
    column: $table.participantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get participantAvatar => $composableBuilder(
    column: $table.participantAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessageContent => $composableBuilder(
    column: $table.lastMessageContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ConversationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTableTable,
          ConversationsTableData,
          $$ConversationsTableTableFilterComposer,
          $$ConversationsTableTableOrderingComposer,
          $$ConversationsTableTableAnnotationComposer,
          $$ConversationsTableTableCreateCompanionBuilder,
          $$ConversationsTableTableUpdateCompanionBuilder,
          (
            ConversationsTableData,
            BaseReferences<
              _$AppDatabase,
              $ConversationsTableTable,
              ConversationsTableData
            >,
          ),
          ConversationsTableData,
          PrefetchHooks Function()
        > {
  $$ConversationsTableTableTableManager(
    _$AppDatabase db,
    $ConversationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> participantName = const Value.absent(),
                Value<String?> participantAvatar = const Value.absent(),
                Value<String?> lastMessageContent = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsTableCompanion(
                id: id,
                type: type,
                participantName: participantName,
                participantAvatar: participantAvatar,
                lastMessageContent: lastMessageContent,
                lastMessageAt: lastMessageAt,
                unreadCount: unreadCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                Value<String?> participantName = const Value.absent(),
                Value<String?> participantAvatar = const Value.absent(),
                Value<String?> lastMessageContent = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsTableCompanion.insert(
                id: id,
                type: type,
                participantName: participantName,
                participantAvatar: participantAvatar,
                lastMessageContent: lastMessageContent,
                lastMessageAt: lastMessageAt,
                unreadCount: unreadCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTableTable,
      ConversationsTableData,
      $$ConversationsTableTableFilterComposer,
      $$ConversationsTableTableOrderingComposer,
      $$ConversationsTableTableAnnotationComposer,
      $$ConversationsTableTableCreateCompanionBuilder,
      $$ConversationsTableTableUpdateCompanionBuilder,
      (
        ConversationsTableData,
        BaseReferences<
          _$AppDatabase,
          $ConversationsTableTable,
          ConversationsTableData
        >,
      ),
      ConversationsTableData,
      PrefetchHooks Function()
    >;
typedef $$MessagesTableTableCreateCompanionBuilder =
    MessagesTableCompanion Function({
      required String id,
      required String conversationId,
      required String senderId,
      required String senderRole,
      required String content,
      Value<String?> fileUrl,
      Value<String> messageType,
      Value<String> status,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MessagesTableTableUpdateCompanionBuilder =
    MessagesTableCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> senderId,
      Value<String> senderRole,
      Value<String> content,
      Value<String?> fileUrl,
      Value<String> messageType,
      Value<String> status,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableFilterComposer({
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

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderRole => $composableBuilder(
    column: $table.senderRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderRole => $composableBuilder(
    column: $table.senderRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderRole => $composableBuilder(
    column: $table.senderRole,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<String> get messageType => $composableBuilder(
    column: $table.messageType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTableTable,
          MessagesTableData,
          $$MessagesTableTableFilterComposer,
          $$MessagesTableTableOrderingComposer,
          $$MessagesTableTableAnnotationComposer,
          $$MessagesTableTableCreateCompanionBuilder,
          $$MessagesTableTableUpdateCompanionBuilder,
          (
            MessagesTableData,
            BaseReferences<
              _$AppDatabase,
              $MessagesTableTable,
              MessagesTableData
            >,
          ),
          MessagesTableData,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableTableManager(_$AppDatabase db, $MessagesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> senderRole = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> fileUrl = const Value.absent(),
                Value<String> messageType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesTableCompanion(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                senderRole: senderRole,
                content: content,
                fileUrl: fileUrl,
                messageType: messageType,
                status: status,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String senderId,
                required String senderRole,
                required String content,
                Value<String?> fileUrl = const Value.absent(),
                Value<String> messageType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesTableCompanion.insert(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                senderRole: senderRole,
                content: content,
                fileUrl: fileUrl,
                messageType: messageType,
                status: status,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTableTable,
      MessagesTableData,
      $$MessagesTableTableFilterComposer,
      $$MessagesTableTableOrderingComposer,
      $$MessagesTableTableAnnotationComposer,
      $$MessagesTableTableCreateCompanionBuilder,
      $$MessagesTableTableUpdateCompanionBuilder,
      (
        MessagesTableData,
        BaseReferences<_$AppDatabase, $MessagesTableTable, MessagesTableData>,
      ),
      MessagesTableData,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableTableCreateCompanionBuilder =
    OrdersTableCompanion Function({
      required String id,
      Value<String?> restaurantId,
      Value<String?> restaurantName,
      required String itemsJson,
      required double total,
      Value<double?> deliveryFee,
      required String status,
      Value<String?> paymentMethod,
      Value<String?> deliveryAddressJson,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<double?> rating,
      Value<int> rowid,
    });
typedef $$OrdersTableTableUpdateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<String> id,
      Value<String?> restaurantId,
      Value<String?> restaurantName,
      Value<String> itemsJson,
      Value<double> total,
      Value<double?> deliveryFee,
      Value<String> status,
      Value<String?> paymentMethod,
      Value<String?> deliveryAddressJson,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<double?> rating,
      Value<int> rowid,
    });

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
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

  ColumnFilters<String> get restaurantName => $composableBuilder(
    column: $table.restaurantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryAddressJson => $composableBuilder(
    column: $table.deliveryAddressJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
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

  ColumnOrderings<String> get restaurantName => $composableBuilder(
    column: $table.restaurantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryAddressJson => $composableBuilder(
    column: $table.deliveryAddressJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
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

  GeneratedColumn<String> get restaurantName => $composableBuilder(
    column: $table.restaurantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get deliveryFee => $composableBuilder(
    column: $table.deliveryFee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryAddressJson => $composableBuilder(
    column: $table.deliveryAddressJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);
}

class $$OrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTableTable,
          OrdersTableData,
          $$OrdersTableTableFilterComposer,
          $$OrdersTableTableOrderingComposer,
          $$OrdersTableTableAnnotationComposer,
          $$OrdersTableTableCreateCompanionBuilder,
          $$OrdersTableTableUpdateCompanionBuilder,
          (
            OrdersTableData,
            BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>,
          ),
          OrdersTableData,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> restaurantId = const Value.absent(),
                Value<String?> restaurantName = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<double?> deliveryFee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> deliveryAddressJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion(
                id: id,
                restaurantId: restaurantId,
                restaurantName: restaurantName,
                itemsJson: itemsJson,
                total: total,
                deliveryFee: deliveryFee,
                status: status,
                paymentMethod: paymentMethod,
                deliveryAddressJson: deliveryAddressJson,
                notes: notes,
                createdAt: createdAt,
                rating: rating,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> restaurantId = const Value.absent(),
                Value<String?> restaurantName = const Value.absent(),
                required String itemsJson,
                required double total,
                Value<double?> deliveryFee = const Value.absent(),
                required String status,
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> deliveryAddressJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion.insert(
                id: id,
                restaurantId: restaurantId,
                restaurantName: restaurantName,
                itemsJson: itemsJson,
                total: total,
                deliveryFee: deliveryFee,
                status: status,
                paymentMethod: paymentMethod,
                deliveryAddressJson: deliveryAddressJson,
                notes: notes,
                createdAt: createdAt,
                rating: rating,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTableTable,
      OrdersTableData,
      $$OrdersTableTableFilterComposer,
      $$OrdersTableTableOrderingComposer,
      $$OrdersTableTableAnnotationComposer,
      $$OrdersTableTableCreateCompanionBuilder,
      $$OrdersTableTableUpdateCompanionBuilder,
      (
        OrdersTableData,
        BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>,
      ),
      OrdersTableData,
      PrefetchHooks Function()
    >;
typedef $$FavoritesTableTableCreateCompanionBuilder =
    FavoritesTableCompanion Function({
      required String restaurantId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });
typedef $$FavoritesTableTableUpdateCompanionBuilder =
    FavoritesTableCompanion Function({
      Value<String> restaurantId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$FavoritesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get restaurantId => $composableBuilder(
    column: $table.restaurantId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$FavoritesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTableTable,
          FavoritesTableData,
          $$FavoritesTableTableFilterComposer,
          $$FavoritesTableTableOrderingComposer,
          $$FavoritesTableTableAnnotationComposer,
          $$FavoritesTableTableCreateCompanionBuilder,
          $$FavoritesTableTableUpdateCompanionBuilder,
          (
            FavoritesTableData,
            BaseReferences<
              _$AppDatabase,
              $FavoritesTableTable,
              FavoritesTableData
            >,
          ),
          FavoritesTableData,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableTableManager(
    _$AppDatabase db,
    $FavoritesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> restaurantId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesTableCompanion(
                restaurantId: restaurantId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String restaurantId,
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesTableCompanion.insert(
                restaurantId: restaurantId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTableTable,
      FavoritesTableData,
      $$FavoritesTableTableFilterComposer,
      $$FavoritesTableTableOrderingComposer,
      $$FavoritesTableTableAnnotationComposer,
      $$FavoritesTableTableCreateCompanionBuilder,
      $$FavoritesTableTableUpdateCompanionBuilder,
      (
        FavoritesTableData,
        BaseReferences<_$AppDatabase, $FavoritesTableTable, FavoritesTableData>,
      ),
      FavoritesTableData,
      PrefetchHooks Function()
    >;
typedef $$OfflineActionsTableTableCreateCompanionBuilder =
    OfflineActionsTableCompanion Function({
      Value<int> id,
      required String actionType,
      required String payload,
      Value<int> retryCount,
      Value<int> maxRetries,
      required DateTime createdAt,
      Value<String> status,
    });
typedef $$OfflineActionsTableTableUpdateCompanionBuilder =
    OfflineActionsTableCompanion Function({
      Value<int> id,
      Value<String> actionType,
      Value<String> payload,
      Value<int> retryCount,
      Value<int> maxRetries,
      Value<DateTime> createdAt,
      Value<String> status,
    });

class $$OfflineActionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineActionsTableTable> {
  $$OfflineActionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineActionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineActionsTableTable> {
  $$OfflineActionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineActionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineActionsTableTable> {
  $$OfflineActionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$OfflineActionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineActionsTableTable,
          OfflineActionsTableData,
          $$OfflineActionsTableTableFilterComposer,
          $$OfflineActionsTableTableOrderingComposer,
          $$OfflineActionsTableTableAnnotationComposer,
          $$OfflineActionsTableTableCreateCompanionBuilder,
          $$OfflineActionsTableTableUpdateCompanionBuilder,
          (
            OfflineActionsTableData,
            BaseReferences<
              _$AppDatabase,
              $OfflineActionsTableTable,
              OfflineActionsTableData
            >,
          ),
          OfflineActionsTableData,
          PrefetchHooks Function()
        > {
  $$OfflineActionsTableTableTableManager(
    _$AppDatabase db,
    $OfflineActionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineActionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineActionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfflineActionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => OfflineActionsTableCompanion(
                id: id,
                actionType: actionType,
                payload: payload,
                retryCount: retryCount,
                maxRetries: maxRetries,
                createdAt: createdAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String actionType,
                required String payload,
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
              }) => OfflineActionsTableCompanion.insert(
                id: id,
                actionType: actionType,
                payload: payload,
                retryCount: retryCount,
                maxRetries: maxRetries,
                createdAt: createdAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineActionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineActionsTableTable,
      OfflineActionsTableData,
      $$OfflineActionsTableTableFilterComposer,
      $$OfflineActionsTableTableOrderingComposer,
      $$OfflineActionsTableTableAnnotationComposer,
      $$OfflineActionsTableTableCreateCompanionBuilder,
      $$OfflineActionsTableTableUpdateCompanionBuilder,
      (
        OfflineActionsTableData,
        BaseReferences<
          _$AppDatabase,
          $OfflineActionsTableTable,
          OfflineActionsTableData
        >,
      ),
      OfflineActionsTableData,
      PrefetchHooks Function()
    >;
typedef $$AiConversationsTableTableCreateCompanionBuilder =
    AiConversationsTableCompanion Function({
      required String id,
      Value<String?> serverId,
      Value<String> title,
      required DateTime lastMessageAt,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$AiConversationsTableTableUpdateCompanionBuilder =
    AiConversationsTableCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> title,
      Value<DateTime> lastMessageAt,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$AiConversationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AiConversationsTableTable,
          AiConversationsTableData
        > {
  $$AiConversationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AiMessagesTableTable, List<AiMessagesTableData>>
  _aiMessagesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.aiMessagesTable,
    aliasName: $_aliasNameGenerator(
      db.aiConversationsTable.id,
      db.aiMessagesTable.conversationId,
    ),
  );

  $$AiMessagesTableTableProcessedTableManager get aiMessagesTableRefs {
    final manager = $$AiMessagesTableTableTableManager(
      $_db,
      $_db.aiMessagesTable,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _aiMessagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AiConversationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiConversationsTableTable> {
  $$AiConversationsTableTableFilterComposer({
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

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aiMessagesTableRefs(
    Expression<bool> Function($$AiMessagesTableTableFilterComposer f) f,
  ) {
    final $$AiMessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiMessagesTable,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiMessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.aiMessagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiConversationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiConversationsTableTable> {
  $$AiConversationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiConversationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiConversationsTableTable> {
  $$AiConversationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> aiMessagesTableRefs<T extends Object>(
    Expression<T> Function($$AiMessagesTableTableAnnotationComposer a) f,
  ) {
    final $$AiMessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiMessagesTable,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiMessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.aiMessagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiConversationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiConversationsTableTable,
          AiConversationsTableData,
          $$AiConversationsTableTableFilterComposer,
          $$AiConversationsTableTableOrderingComposer,
          $$AiConversationsTableTableAnnotationComposer,
          $$AiConversationsTableTableCreateCompanionBuilder,
          $$AiConversationsTableTableUpdateCompanionBuilder,
          (AiConversationsTableData, $$AiConversationsTableTableReferences),
          AiConversationsTableData,
          PrefetchHooks Function({bool aiMessagesTableRefs})
        > {
  $$AiConversationsTableTableTableManager(
    _$AppDatabase db,
    $AiConversationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiConversationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiConversationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiConversationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> lastMessageAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsTableCompanion(
                id: id,
                serverId: serverId,
                title: title,
                lastMessageAt: lastMessageAt,
                createdAt: createdAt,
                isSynced: isSynced,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                Value<String> title = const Value.absent(),
                required DateTime lastMessageAt,
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsTableCompanion.insert(
                id: id,
                serverId: serverId,
                title: title,
                lastMessageAt: lastMessageAt,
                createdAt: createdAt,
                isSynced: isSynced,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiConversationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aiMessagesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (aiMessagesTableRefs) db.aiMessagesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aiMessagesTableRefs)
                    await $_getPrefetchedData<
                      AiConversationsTableData,
                      $AiConversationsTableTable,
                      AiMessagesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$AiConversationsTableTableReferences
                          ._aiMessagesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AiConversationsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).aiMessagesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.conversationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AiConversationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiConversationsTableTable,
      AiConversationsTableData,
      $$AiConversationsTableTableFilterComposer,
      $$AiConversationsTableTableOrderingComposer,
      $$AiConversationsTableTableAnnotationComposer,
      $$AiConversationsTableTableCreateCompanionBuilder,
      $$AiConversationsTableTableUpdateCompanionBuilder,
      (AiConversationsTableData, $$AiConversationsTableTableReferences),
      AiConversationsTableData,
      PrefetchHooks Function({bool aiMessagesTableRefs})
    >;
typedef $$AiMessagesTableTableCreateCompanionBuilder =
    AiMessagesTableCompanion Function({
      Value<int> id,
      required String conversationId,
      required String role,
      required String content,
      Value<int?> tokenCount,
      required DateTime createdAt,
      Value<bool> isSynced,
    });
typedef $$AiMessagesTableTableUpdateCompanionBuilder =
    AiMessagesTableCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<String> role,
      Value<String> content,
      Value<int?> tokenCount,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$AiMessagesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AiMessagesTableTable,
          AiMessagesTableData
        > {
  $$AiMessagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AiConversationsTableTable _conversationIdTable(_$AppDatabase db) =>
      db.aiConversationsTable.createAlias(
        $_aliasNameGenerator(
          db.aiMessagesTable.conversationId,
          db.aiConversationsTable.id,
        ),
      );

  $$AiConversationsTableTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$AiConversationsTableTableTableManager(
      $_db,
      $_db.aiConversationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiMessagesTableTable> {
  $$AiMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AiConversationsTableTableFilterComposer get conversationId {
    final $$AiConversationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.aiConversationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiConversationsTableTableFilterComposer(
            $db: $db,
            $table: $db.aiConversationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiMessagesTableTable> {
  $$AiMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AiConversationsTableTableOrderingComposer get conversationId {
    final $$AiConversationsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.aiConversationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiConversationsTableTableOrderingComposer(
                $db: $db,
                $table: $db.aiConversationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AiMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiMessagesTableTable> {
  $$AiMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AiConversationsTableTableAnnotationComposer get conversationId {
    final $$AiConversationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.aiConversationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiConversationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.aiConversationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AiMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiMessagesTableTable,
          AiMessagesTableData,
          $$AiMessagesTableTableFilterComposer,
          $$AiMessagesTableTableOrderingComposer,
          $$AiMessagesTableTableAnnotationComposer,
          $$AiMessagesTableTableCreateCompanionBuilder,
          $$AiMessagesTableTableUpdateCompanionBuilder,
          (AiMessagesTableData, $$AiMessagesTableTableReferences),
          AiMessagesTableData,
          PrefetchHooks Function({bool conversationId})
        > {
  $$AiMessagesTableTableTableManager(
    _$AppDatabase db,
    $AiMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiMessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiMessagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int?> tokenCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => AiMessagesTableCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                tokenCount: tokenCount,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required String role,
                required String content,
                Value<int?> tokenCount = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
              }) => AiMessagesTableCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                tokenCount: tokenCount,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiMessagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conversationId,
                                referencedTable:
                                    $$AiMessagesTableTableReferences
                                        ._conversationIdTable(db),
                                referencedColumn:
                                    $$AiMessagesTableTableReferences
                                        ._conversationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AiMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiMessagesTableTable,
      AiMessagesTableData,
      $$AiMessagesTableTableFilterComposer,
      $$AiMessagesTableTableOrderingComposer,
      $$AiMessagesTableTableAnnotationComposer,
      $$AiMessagesTableTableCreateCompanionBuilder,
      $$AiMessagesTableTableUpdateCompanionBuilder,
      (AiMessagesTableData, $$AiMessagesTableTableReferences),
      AiMessagesTableData,
      PrefetchHooks Function({bool conversationId})
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
  $$PendingActionsTableTableTableManager get pendingActionsTable =>
      $$PendingActionsTableTableTableManager(_db, _db.pendingActionsTable);
  $$MenuItemsTableTableTableManager get menuItemsTable =>
      $$MenuItemsTableTableTableManager(_db, _db.menuItemsTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(_db, _db.conversationsTable);
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db, _db.messagesTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$FavoritesTableTableTableManager get favoritesTable =>
      $$FavoritesTableTableTableManager(_db, _db.favoritesTable);
  $$OfflineActionsTableTableTableManager get offlineActionsTable =>
      $$OfflineActionsTableTableTableManager(_db, _db.offlineActionsTable);
  $$AiConversationsTableTableTableManager get aiConversationsTable =>
      $$AiConversationsTableTableTableManager(_db, _db.aiConversationsTable);
  $$AiMessagesTableTableTableManager get aiMessagesTable =>
      $$AiMessagesTableTableTableManager(_db, _db.aiMessagesTable);
}
