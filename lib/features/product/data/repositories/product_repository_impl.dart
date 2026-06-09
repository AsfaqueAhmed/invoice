import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<List<Product>> getAll() => _datasource.getAll();

  @override
  Future<void> create(Product product) => _datasource.create(product);

  @override
  Future<void> update(Product product) => _datasource.update(product);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
