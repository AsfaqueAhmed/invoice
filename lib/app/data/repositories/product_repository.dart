import '../datasources/local/product_local_datasource.dart';
import '../entities/product_entity.dart';

class ProductRepository {
  final ProductLocalDatasource _datasource;

  ProductRepository(this._datasource);

  Future<List<ProductEntity>> getAll() => _datasource.getAll();

  Future<void> create(ProductEntity item) => _datasource.create(item);

  Future<void> update(ProductEntity item) => _datasource.update(item);

  Future<void> delete(String id) => _datasource.delete(id);
}
