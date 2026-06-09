import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<void> create(Product product);
  Future<void> update(Product product);
  Future<void> delete(String id);
}
