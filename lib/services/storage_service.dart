import '../core/errors/app_exception.dart';

/// Contract for persistent local storage
abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

/// In-memory reference implementation of [StorageService]
class MemoryStorageService implements StorageService {
  final Map<String, String> _storage = {};

  @override
  Future<void> setString(String key, String value) async {
    try {
      _storage[key] = value;
    } catch (e) {
      throw CacheException(message: 'Failed to write to storage: $e');
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _storage[key];
    } catch (e) {
      throw CacheException(message: 'Failed to read from storage: $e');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      _storage.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove from storage: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      _storage.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: $e');
    }
  }
}
