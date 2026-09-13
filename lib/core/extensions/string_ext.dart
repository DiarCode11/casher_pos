// lib/core/extensions/string_extension.dart

extension StringExt on String {
  /// Membersihkan string berformat (misal "Rp 15.000") jadi int murni (15000)
  int toCleanInt() {
    final cleaned = replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.isEmpty ? 0 : int.parse(cleaned);
  }

  /// Versi double, untuk kasus butuh desimal (format Indonesia: titik ribuan, koma desimal)
  double toCleanDouble() {
    final cleaned = replaceAll('.', '').replaceAll(',', '.');
    final digitsAndDot = cleaned.replaceAll(RegExp(r'[^0-9.]'), '');
    return digitsAndDot.isEmpty ? 0.0 : double.parse(digitsAndDot);
  }
}