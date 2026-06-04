import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' show MultipartFile;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/models/loyalty_model.dart';
import 'package:cliceat_app/core/network/services/user_service.dart';

/// Abstracts user profile, addresses and loyalty data.
@lazySingleton
class UserRepository {
  final UserService _service;
  final FlutterSecureStorage _secureStorage;

  static const _profileCacheKey = 'cached_user_profile';
  static const _addressesCacheKey = 'cached_user_addresses';

  UserRepository(this._service, this._secureStorage);

  // ─── Profile ──────────────────────────────────────────────────────────────

  Future<Either<AppError, UserModel>> getProfile() async {
    try {
      final res = await _service.getMe();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data =
            body['data'] as Map<String, dynamic>? ?? body;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        final user = UserModel.fromJson(userData);
        await _cacheProfile(user);
        return Right(user);
      }
      final cached = await _loadCachedProfile();
      if (cached != null) return Right(cached);
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      final cached = await _loadCachedProfile();
      if (cached != null) return Right(cached);
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, UserModel>> updateProfile(
      Map<String, dynamic> data) async {
    try {
      final res = await _service.updateMe(data);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        final updated = UserModel.fromJson(userData);
        await _cacheProfile(updated);
        return Right(updated);
      }
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, UserModel>> updateProfilePhoto(File file) async {
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final contentType = switch (ext) {
        'png' => MediaType('image', 'png'),
        'webp' => MediaType('image', 'webp'),
        'gif' => MediaType('image', 'gif'),
        _ => MediaType('image', 'jpeg'),
      };
      final multipartFile = await MultipartFile.fromPath(
        'photo',
        file.path,
        contentType: contentType,
      );
      final res = await _service.updateProfilePhoto(multipartFile);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        final updated = UserModel.fromJson(userData);
        await _cacheProfile(updated);
        return Right(updated);
      }
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Addresses ────────────────────────────────────────────────────────────

  Future<Either<AppError, List<AddressModel>>> getAddresses() async {
    try {
      final res = await _service.getAddresses();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'];
        List<dynamic> raw = [];
        if (data is List) {
          raw = data;
        } else if (data is Map<String, dynamic>) {
          raw = data['addresses'] as List<dynamic>? ?? [];
        }
        final addresses = raw
            .whereType<Map<String, dynamic>>()
            .map(AddressModel.fromJson)
            .toList();
        await _cacheAddresses(addresses);
        return Right(addresses);
      }
      final cached = await _loadCachedAddresses();
      if (cached.isNotEmpty) return Right(cached);
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      final cached = await _loadCachedAddresses();
      if (cached.isNotEmpty) return Right(cached);
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, AddressModel>> addAddress(
      Map<String, dynamic> data) async {
    try {
      final res = await _service.addAddress(data);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final dataField = body['data'];
        AddressModel? addr;
        if (dataField is Map<String, dynamic>) {
          if (dataField.containsKey('addresses')) {
            final list = dataField['addresses'] as List<dynamic>;
            if (list.isNotEmpty) {
              addr = AddressModel.fromJson(list.last as Map<String, dynamic>);
            }
          } else {
            addr = AddressModel.fromJson(dataField);
          }
        }
        addr ??= AddressModel.fromJson(body);
        return Right(addr);
      }
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<AddressModel>>> updateAddress(
      String id, Map<String, dynamic> data) async {
    try {
      final res = await _service.updateAddress(id, data);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final dataField = body['data'];
        List<dynamic> raw = [];
        if (dataField is List) {
          raw = dataField;
        } else if (dataField is Map<String, dynamic>) {
          raw = dataField['addresses'] as List<dynamic>? ?? [];
        }
        final addresses = raw
            .whereType<Map<String, dynamic>>()
            .map(AddressModel.fromJson)
            .toList();
        await _cacheAddresses(addresses);
        return Right(addresses);
      }
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> deleteAddress(String id) async {
    try {
      final res = await _service.deleteAddress(id);
      if (res.isSuccessful) {
        await _removeAddressFromCache(id);
        return const Right(null);
      }
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Loyalty ──────────────────────────────────────────────────────────────

  Future<Either<AppError, LoyaltyModel>> getLoyalty() async {
    try {
      final res = await _service.getLoyalty();
      if (res.isSuccessful && res.body != null) {
        return Right(LoyaltyModel.fromJson(res.body!));
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── FCM token ────────────────────────────────────────────────────────────

  Future<void> registerFcmToken(String token, {String? lang}) async {
    try {
      await _service.registerFcmToken({
        'token': token,
        'language': lang,
      });
    } catch (_) {}
  }

  Future<void> unregisterFcmToken(String token) async {
    try {
      await _service.unregisterFcmToken({'token': token});
    } catch (_) {}
  }

  // ─── Cache helpers ────────────────────────────────────────────────────────

  Future<void> _cacheProfile(UserModel user) async {
    try {
      await _secureStorage.write(
          key: _profileCacheKey, value: jsonEncode(user.toJson()));
    } catch (_) {}
  }

  Future<UserModel?> _loadCachedProfile() async {
    try {
      final raw = await _secureStorage.read(key: _profileCacheKey);
      if (raw == null) return null;
      return UserModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheAddresses(List<AddressModel> addresses) async {
    try {
      await _secureStorage.write(
          key: _addressesCacheKey,
          value: jsonEncode(addresses.map((a) => a.toJson()).toList()));
    } catch (_) {}
  }

  Future<List<AddressModel>> _loadCachedAddresses() async {
    try {
      final raw = await _secureStorage.read(key: _addressesCacheKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _removeAddressFromCache(String id) async {
    try {
      final addresses = await _loadCachedAddresses();
      final updated = addresses.where((a) => a.id != id).toList();
      await _cacheAddresses(updated);
    } catch (_) {}
  }

  Future<void> clearCache() async {
    await _secureStorage.delete(key: _profileCacheKey);
    await _secureStorage.delete(key: _addressesCacheKey);
  }
}
