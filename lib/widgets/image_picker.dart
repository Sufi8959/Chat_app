import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;
  @override
  State<StatefulWidget> createState() {
    return _ImagePickerWidgetState();
  }
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImageFile;
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 50, maxHeight: 150);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image_outlined),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
