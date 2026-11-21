import '../core/errors/app_exception.dart';
import '../core/errors/app_failure.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'base_repository.dart';

/// Repository coordinating remote API calls and local persistence for [ItemModel]
class ItemRepository implements BaseRepository<ItemModel> {
  final ApiService _apiService;
  final StorageService _storageService;

  ItemRepository({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? MemoryStorageService();

  @override
  Future<List<ItemModel>> getAll() async {
    try {
      await _apiService.get('/items');
      return <ItemModel>[];
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<ItemModel?> getById(String id) async {
    try {
      await _apiService.get('/items/$id');
      return null;
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<void> add(ItemModel item) async {
    try {
      await _apiService.post('/items', data: item.toJson());
      await _storageService.setString('last_saved_item', item.id);
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<void> update(ItemModel item) async {
    try {
      await _apiService.put('/items/${item.id}', data: item.toJson());
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _apiService.delete('/items/$id');
    } on AppException catch (e) {
      throw ServerFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }
}
