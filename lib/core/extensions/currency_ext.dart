import 'package:intl/intl.dart';

extension CurrencyFormat on int {
  String toRupiah() {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }
}