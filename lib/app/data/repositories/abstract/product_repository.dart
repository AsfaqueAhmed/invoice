
import '../../entities/product_entity.dart';

abstract class ProductRepository {

  Future<List<ProductEntity>> getAll();

  Future<void> create(
    ProductEntity item,
  );

  Future<void> update(
    ProductEntity item,
  );

  Future<void> delete(
    String id,
  );
}
