import 'package:get_storage/get_storage.dart';

abstract class LocalStorageService {
  static const String boxName = 'invoice_app';
  static const _onCreateFirstBusiness = 'createFirstBusiness';
  static const _themeMode = 'themeMode';
  static const _invoicePrefix = 'invoicePrefix';

  static late final GetStorage _storage;

  static Future<void> init() async {
    await GetStorage.init(boxName);
    _storage = GetStorage(boxName);
  }

  static bool get hasCreatedFirstBusiness =>
      _storage.read<bool>(_onCreateFirstBusiness) ?? false;

  static Future<void> setOnCreatedFirstBusiness() async {
    await _storage.write(_onCreateFirstBusiness, true);
  }

  static Future<void> resetOnCreatedFirstBusiness() async {
    await _storage.remove(_onCreateFirstBusiness);
  }

  static String? get themeMode => _storage.read<String>(_themeMode);

  static Future<void> setThemeMode(String mode) async {
    await _storage.write(_themeMode, mode);
  }

  static String? get invoicePrefix => _storage.read<String>(_invoicePrefix);

  static Future<void> setInvoicePrefix(String prefix) async {
    await _storage.write(_invoicePrefix, prefix);
  }

}
