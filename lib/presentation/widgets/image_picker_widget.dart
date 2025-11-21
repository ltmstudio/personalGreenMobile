import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'full_screen_image_widget.dart';

class MultiImagePickerWidget extends StatefulWidget {
  const MultiImagePickerWidget({
    super.key,
    this.padding,
    this.onImagesChanged,
  });
  final EdgeInsetsGeometry? padding;
  final ValueChanged<List<XFile>>? onImagesChanged;

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(); // multiple select
    if (picked.isNotEmpty) {
      setState(() {
        if (_images.length + picked.length <= 10) {
          _images.addAll(picked);
        } else {
          final remaining = 10 - _images.length;
          _images.addAll(picked.take(remaining));
        }
      });
      widget.onImagesChanged?.call(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged?.call(_images);
  }

  void _openFullScreenViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FullScreenImageViewer(images: _images, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length + 1,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20.0),

        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            // Add button
            return GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.grey),
              ),
            );
          }

          final file = File(_images[index].path);
          return GestureDetector(
            onTap: () => _openFullScreenViewer(index),

            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
