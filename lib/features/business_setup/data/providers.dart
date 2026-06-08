import 'package:flutter_getx_app/app/core/providers/shared_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'datasources/business_local_datasource.dart';
import 'repositories/business_repository.dart';

final businessLocalDatasourceProvider = Provider<BusinessLocalDatasource>(
  (ref) => BusinessLocalDatasource(ref.watch(databaseServiceProvider)),
);

final businessRepositoryProvider = Provider<BusinessRepository>(
  (ref) => BusinessRepository(ref.watch(businessLocalDatasourceProvider)),
);
