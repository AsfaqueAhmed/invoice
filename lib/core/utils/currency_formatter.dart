abstract class CurrencyFormatter {
  static String format(double value) {
    if (value >= 1000) {
      return '\$${value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}
