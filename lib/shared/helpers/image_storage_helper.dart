// lib/core/utils/image_storage_helper.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageStorageHelper {
  /// Copy file gambar ke folder khusus app, return path barunya
  static Future<String> saveImage(File imageFile, {String prefix = 'img'}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/product_images');

    // buat folder kalau belum ada
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final extension = p.extension(imageFile.path); // .jpg, .png, dll
    final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final newPath = '${imagesDir.path}/$fileName';

    final savedFile = await imageFile.copy(newPath);
    return savedFile.path;
  }

  /// Hapus file gambar lama (dipakai saat update/delete produk)
  static Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}