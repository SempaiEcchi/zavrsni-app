import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hive_storage_service.dart';

/// Static class for defining keys for storing values
class LocalStorageKeys {}

final storageServiceProvider = Provider<StorageService>(
  (_) => HiveStorageService(),
);

/// Abstract class defining [StorageService] structure
abstract class StorageService {
  Future<void> initialize();

  /// Delete value by key
  Future<void> deleteValue(String key);

  /// Get value by key
  String? getValue(String key);

  /// Get all keys and values
  dynamic getAll();

  /// Clear storage
  Future<void> clear();

  /// Check if key has value
  bool hasValue(String key);

  /// Store new value
  Future<void> setValue({required String key, required String? data});
}
