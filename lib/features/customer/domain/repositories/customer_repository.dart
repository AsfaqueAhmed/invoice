import '../models/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getAll();
  Future<void> create(Customer customer);
  Future<void> update(Customer customer);
  Future<void> delete(String id);
}
