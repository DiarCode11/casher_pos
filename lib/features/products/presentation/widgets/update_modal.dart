import 'dart:io';

import 'package:casher_pos/core/di/injection.dart';
import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/products/data/dtos/store_product_dto.dart';
import 'package:casher_pos/features/products/data/dtos/update_product_dto.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/shared/widgets/image_picker_input.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:casher_pos/shared/utils/rupiah_input_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateModal extends StatefulWidget {
  final ProductModel model;
  const UpdateModal({super.key, required this.model});

  @override
  State<UpdateModal> createState() => _UpdateModalState();
}

class _UpdateModalState extends State<UpdateModal> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _selectedCategory;
  File? _selectedImage;

  String? _nameError;
  String? _priceError;

  bool _validate() {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? 'Nama produk wajib diisi'
          : null;

      _priceError = _priceController.text.trim().isEmpty
          ? 'Harga wajib diisi'
          : null;
    });

    return _nameError == null && _priceError == null;
  }

  Future<void> _submit() async {
    if (_validate()) {
      final dto = UpdateProductDto(
        id: widget.model.id!,
        name: _nameController.text.trim(),
        price: _priceController.text,
        image: _selectedImage,
        categoryId: 1,
      );

      final productCubit = context.read<ProductCubit>();
      final res = await productCubit.updateProduct(widget.model.id!, dto);
      print("Response: ${res.response}");
      await productCubit.loadProducts();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model.name);
    _priceController = TextEditingController(text: NumberFormat.decimalPattern('id_ID').format(widget.model.price));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ganti AlertDialog dengan Dialog biasa agar scrollbar aman di dalam batas kontainer
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. HEADER (Judul & Tombol Close)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Update Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),

            // 2. CONTENT (Bisa di-scroll dengan aman dan scrollbar nempel rapi)
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Produk',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        errorText: _nameError,
                        hintText: 'Masukkan nama produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Harga (Rp)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _priceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        RupiahInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        errorText: _priceError,
                        hintText: 'Masukkan harga produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ImagePickerInput(
                      initialImage: widget.model.imagePath != null ? File(widget.model.imagePath!) : null,
                      onImagePicked: (file) {
                        setState(() {
                          _selectedImage = file;
                        });
                      }, 
                      label: "Gambar Produk",
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Kategori',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    DropdownFlutter<String>(
                      hintText: 'Select priority',
                      closedHeaderPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      expandedHeaderPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: CustomDropdownDecoration(
                        closedBorder: Border.all(width: 1, color: Colors.grey.shade600),
                        expandedBorder: Border.all(width: 1),
                      ),
                      items: const ['Low', 'Medium', 'High', 'Urgent'],
                      initialItem: 'Medium',
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // 3. ACTIONS (Tombol Batal & Simpan di bagian bawah)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600, // Warna background tombol
                      foregroundColor: Colors.white,       // Warna teks & ikon di dalam tombol
                      elevation: 2,                        // (Opsional) Tingkat bayangan
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Ukuran padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Membuat sudut tombol melengkung
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}