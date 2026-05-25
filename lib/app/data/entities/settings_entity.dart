class SettingsEntity {
  final bool darkMode;
  final String language;
  final String invoicePrefix;
  final bool enableTax;

  SettingsEntity({
    required this.darkMode,
    required this.language,
    required this.invoicePrefix,
    required this.enableTax,
  });

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode ? 1 : 0,
      'language': language,
      'invoicePrefix': invoicePrefix,
      'enableTax': enableTax ? 1 : 0,
    };
  }

  factory SettingsEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return SettingsEntity(
      darkMode: map['darkMode'] == 1,
      language: map['language'],
      invoicePrefix: map['invoicePrefix'],
      enableTax: map['enableTax'] == 1,
    );
  }
}
