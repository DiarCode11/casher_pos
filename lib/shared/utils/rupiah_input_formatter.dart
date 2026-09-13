import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // tambahkan package intl

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // kalau kosong, biarkan kosong
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // ambil hanya angka, buang semua karakter non-digit (titik, huruf, dll)
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return oldValue;
    }

    // parse ke integer
    final number = int.parse(digitsOnly);

    // format pakai titik sebagai pemisah ribuan (format Indonesia)
    final formatter = NumberFormat.decimalPattern('id_ID');
    String newText = formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}