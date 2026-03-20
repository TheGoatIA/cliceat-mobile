import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/models/loyalty_model.dart';
import 'package:cliceat_app/core/network/services/user_service.dart';

/// Abstracts user profile, addresses and loyalty data.
class UserRepository {
  final UserService _service;

  static const _profileCacheKey = 'cached_user_profile';
  static const _addressesCacheKey = 'cached_user_addresses';

  UserRepository(this._service);

  // ─── Profile ──────────────────────────────────────────────────────────────

  Future<Either<AppError, UserModel>> getProfile() async {
    try {
      final res = await _service.getMe();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data =
            body['data'] as Map<String, dynamic>? ?? body;
        final user = UserModel.fromJson(data);
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
        final updated =
            UserModel.fromJson(body['data'] as Map<String, dynamic>? ?? body);
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
        final raw = res.body!['data'] as List<dynamic>? ?? [];
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
        final addr = AddressModel.fromJson(
            body['data'] as Map<String, dynamic>? ?? body);
        return Right(addr);
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

  Future<void> registerFcmToken(String token) async {
    try {
      await _service.registerFcmToken({'token': token});
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _profileCacheKey, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  Future<UserModel?> _loadCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_profileCacheKey);
      if (raw == null) return null;
      return UserModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheAddresses(List<AddressModel> addresses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_addressesCacheKey,
          jsonEncode(addresses.map((a) => a.toJson()).toList()));
    } catch (_) {}
  }

  Future<List<AddressModel>> _loadCachedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_addressesCacheKey);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileCacheKey);
    await prefs.remove(_addressesCacheKey);
  }
}
