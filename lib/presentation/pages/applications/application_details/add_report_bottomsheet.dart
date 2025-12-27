import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddReportBottomSheet extends StatefulWidget {
  const AddReportBottomSheet({
    super.key,
    required this.ticketId,
    required this.onSubmit,
  });

  final int? ticketId;

  /// comment + photos (files)
  final Future<void> Function(String comment, List<File> photos) onSubmit;

  @override
  State<AddReportBottomSheet> createState() => _AddReportBottomSheetState();
}

class _AddReportBottomSheetState extends State<AddReportBottomSheet> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();

  bool _sending = false;
  final List<File> _photos = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final items = await _picker.pickMultiImage(imageQuality: 85);
    if (items.isEmpty) return;

    setState(() {
      _photos.addAll(items.map((x) => File(x.path)));
    });
  }

  Future<void> _pickFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (x == null) return;

    setState(() {
      _photos.add(File(x.path));
    });
  }

  void _removeAt(int index) {
    setState(() => _photos.removeAt(index));
  }

  Future<void> _submit() async {
    final comment = _controller.text.trim();
    if (comment.isEmpty && _photos.isEmpty) {
      // минимальная валидация: отчет не пустой
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте текст или фото')),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      await widget.onSubmit(comment, _photos);
      if (!mounted) return;
      Navigator.of(context).pop(true); // success
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Добавить отчет',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _controller,
              minLines: 4,
              maxLines: 8,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Введите текст отчета...',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sending ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Галерея'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sending ? null : _pickFromCamera,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Камера'),
                  ),
                ),
              ],
            ),

            if (_photos.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 74,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _photos[i],
                            width: 74,
                            height: 74,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: _sending ? null : () => _removeAt(i),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _sending ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _sending
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Отправить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
