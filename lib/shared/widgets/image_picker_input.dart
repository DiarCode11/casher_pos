import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerInput extends StatefulWidget {
  final String? label;
  final void Function(File? file) onImagePicked;
  final File? initialImage;

  const ImagePickerInput({
    super.key,
    this.label,
    required this.onImagePicked,
    this.initialImage,
  });

  @override
  State<ImagePickerInput> createState() => _ImagePickerInputState();
}

class _ImagePickerInputState extends State<ImagePickerInput> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (result.isNotEmpty && result.single.path != null) {
        final file = File(result.single.path!);
        setState(() => _selectedImage = file);
        widget.onImagePicked(file);
      }
    } catch (e) {
      debugPrint('❌ Error pick image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
    widget.onImagePicked(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
        ],
        GestureDetector(
          onTap: _isLoading ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 40, color: Colors.grey.shade500),
                          const SizedBox(height: 8),
                          Text(
                            'Klik untuk pilih gambar',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                                minimumSize: const Size(28, 28),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: _removeImage,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}