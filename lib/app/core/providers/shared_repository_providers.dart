import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_service.dart';

/// Shared `DatabaseService` provider — every feature's data layer watches
/// this so they all reuse the same singleton instance the GetX
/// `InitialBinding` uses, instead of opening separate DB connections.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
