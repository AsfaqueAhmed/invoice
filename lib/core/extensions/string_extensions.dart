extension StringExtensions on String? {
  String get initials {
    if (notNullNotEmpty) {
      final parts = this!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return this![0].toUpperCase();
    }
    return '';
  }

  bool get notNullNotEmpty {
    return this != null && this!.isNotEmpty;
  }
}
