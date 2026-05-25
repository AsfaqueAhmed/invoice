
import '../../entities/product_entity.dart';
import '../../datasources/local/product_local_datasource.dart';
import '../abstract/product_repository.dart';

class ProductRepositoryImpl
    implements ProductRepository {

  final ProductLocalDatasource datasource;

  ProductRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<ProductEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    ProductEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    ProductEntity item,
  ) {
    return datasource.update(item);
  }

  @override
  Future<void> delete(
    String id,
  ) {
    return datasource.delete(id);
  }
}
