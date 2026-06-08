import 'package:flutter_getx_app/app/core/providers/shared_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'datasources/customer_local_datasource.dart';
import 'repositories/customer_repository.dart';

final customerLocalDatasourceProvider = Provider<CustomerLocalDatasource>(
  (ref) => CustomerLocalDatasource(ref.watch(databaseServiceProvider)),
);

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepository(ref.watch(customerLocalDatasourceProvider)),
);
