import 'package:casher_pos/core/extensions/currency_ext.dart';
import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    // Jika teks kosong, kembalikan kosong
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hapus semua karakter selain angka (biar aman dari paste text)
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numericOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format angka tambahkan titik ribuan
    String formatted = numericOnly.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    // Kembalikan teks yang sudah diformat dan taruh kursor di paling kanan
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// 1. Ubah menjadi StatefulWidget
class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  // 2. Deklarasikan Controller di dalam State
  late final TextEditingController _cashController;

  @override
  void initState() {
    super.initState();
    _cashController = TextEditingController(text: '0');
    _cashController.addListener(_onCashChanged);
  }

  void _onCashChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    // 3. Dispose controller dengan aman di sini
    _cashController.dispose();
    super.dispose();
  }

  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '', // Kosongkan jika prefix 'Rp ' sudah ada di InputDecoration
    decimalDigits: 0,
  );

  void _openSaveConfirmation(BuildContext context) {
    // Ambil data item keranjang dan nilai cash saat ini
    final cartItems = context.read<CartCubit>().state.items;
    final int subtotal = context.read<CartCubit>().getSubTotal();
    final cartCubit = context.read<CartCubit>();
    
    // Ambil nilai cash dari controller dan bersihkan titiknya
    String rawCash = _cashController.text;
    int cashAmount = rawCash.isEmpty ? 0 : int.parse(rawCash.replaceAll('.', ''));
    int change = cashAmount - subtotal;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail Pembelian'),
          backgroundColor: Colors.white,
          
          // ✅ 1. MEMBUAT DIALOG LEBIH LEBAR
          constraints: const BoxConstraints(
            minWidth: 600, // Atur lebar minimum dialog sesuai keinginan
            maxWidth: 700,
          ),
          
          content: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView( // Agar aman jika item keranjang banyak (bisa di-scroll ke bawah)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ 2. TABEL DINAMIS DARI KERANJANG
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(3), // Nama Produk (lebih lebar)
                      1: FlexColumnWidth(1), // Jumlah (Qty)
                      2: FlexColumnWidth(2), // Harga Satuan
                      3: FlexColumnWidth(2), // Total Per Item
                    },
                    children: [
                      // Baris Header Tabel
                      const TableRow(
                        decoration: BoxDecoration(color: Colors.green),
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Nama Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Qty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Harga', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                        ],
                      ),
                      
                      // Masukkan data item keranjang secara otomatis menggunakan .map()
                      for (var item in cartItems)
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.all(8.0), child: Text(item.name)),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${item.quantity}', textAlign: TextAlign.center)),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text(item.price.toRupiah(), textAlign: TextAlign.right)),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text((item.price * item.quantity).toRupiah(), textAlign: TextAlign.right)),
                          ],
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // ✅ 3. RINGKASAN PEMBAYARAN (Subtotal, Cash, Kembalian)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(subtotal.toRupiah(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cash:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                      Text(cashAmount.toRupiah(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kembalian:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                      Text(change < 0 ? 'Rp 0' : change.toRupiah(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Logika simpan transaksi ke database / cetak struk di sini
                Navigator.pop(context);
                cartCubit.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaksi berhasil dibuat!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2), // Durasi tampil
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Konfirmasi & Cetak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state.items;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.grey.shade200, width: 2),
        ),
      ),
      child: Column(
        children: [
          // Header cart
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(LucideIcons.shoppingCart),
                SizedBox(width: 10,),
                Text(
                  'Keranjang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // List item cart, mengisi sisa tinggi
          Expanded(
            child: cartItems.isEmpty ? Center(
              child: Text("Keranjang kosong", style: TextStyle(color: Colors.grey.shade500),)
              )
            : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index]; 
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${(item.price * item.quantity).toRupiah()} (${item.quantity} pcs)', 
                                style: const TextStyle(fontSize: 14),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 22, 
                                      minHeight: 22,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.green, 
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    onPressed: () => context.read<CartCubit>().decreaseQtyItem(item.productId), 
                                    icon: const Icon(LucideIcons.minus, color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 22, 
                                      minHeight: 22,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    onPressed: () => context.read<CartCubit>().increaseQtyItem(item.productId), 
                                    icon: const Icon(LucideIcons.plus, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Footer total & tombol bayar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 2, color: Colors.grey)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal Produk', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        (context.watch<CartCubit>().getSubTotal()).toRupiah(), 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cash', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          onChanged: (value) {
                            // 1. Ambil hanya karakter angka
                            String cleanText = value.replaceAll(RegExp(r'[^0-9]'), '');

                            // 2. Parse ke int (otomatis mengubah "000" jadi 0)
                            int number = int.tryParse(cleanText) ?? 0;

                            // 3. Format kembali ke string berpemisah titik (contoh: 50000 -> "50.000", 0 -> "0")
                            String formattedText = _formatter.format(number).trim();

                            // 4. Update nilai controller jika teks berubah agar kursor tetap di posisi akhir
                            if (_cashController.text != formattedText) {
                              _cashController.value = TextEditingValue(
                                text: formattedText,
                                selection: TextSelection.collapsed(offset: formattedText.length),
                              );
                            }
                          },
                          controller: _cashController, // Terhubung ke state controller
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green, fontSize: 16),
                          decoration: const InputDecoration(
                            prefixText: 'Rp ',
                            prefixStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 4),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Builder(
                      builder: (context) {
                        final cleanText = _cashController.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final cashAmount = int.tryParse(cleanText) ?? 0;
                        final subTotal = context.watch<CartCubit>().getSubTotal();
                        final isPayable = cashAmount >= subTotal && subTotal > 0;

                        return TextButton(
                          onPressed: isPayable ? () => _openSaveConfirmation(context) : null,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: isPayable ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Bayar', style: TextStyle(fontSize: 17, color: Colors.white)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}