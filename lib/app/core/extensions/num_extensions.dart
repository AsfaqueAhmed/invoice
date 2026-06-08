extension NumExtensions on num {
  String get asCurrency {
    final formatted = toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '\$$formatted';
  }
}
