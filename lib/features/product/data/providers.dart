import 'package:flutter_getx_app/app/core/providers/shared_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'datasources/product_local_datasource.dart';
import 'repositories/product_repository.dart';

final productLocalDatasourceProvider = Provider<ProductLocalDatasource>(
  (ref) => ProductLocalDatasource(ref.watch(databaseServiceProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.watch(productLocalDatasourceProvider)),
);
