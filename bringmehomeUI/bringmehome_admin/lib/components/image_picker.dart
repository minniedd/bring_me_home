import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImageBase64;
  final ValueChanged<String?> onImageChanged;

  const ImagePickerWidget({
    super.key,
    this.initialImageBase64,
    required this.onImageChanged,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  String? _currentImageBase64;

  @override
  void initState() {
    super.initState();
    _currentImageBase64 = widget.initialImageBase64;
  }

  @override
  void didUpdateWidget(covariant ImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImageBase64 != oldWidget.initialImageBase64) {
      setState(() {
        _currentImageBase64 = widget.initialImageBase64;
        _imageFile = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        setState(() {
          _imageFile = File(image.path);
          _currentImageBase64 = base64String;
        });
        widget.onImageChanged(base64String);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image selected successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected.')));
      }
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
      _currentImageBase64 = null;
    });
    widget.onImageChanged(null);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageDisplayWidget;

    if (_imageFile != null) {
      imageDisplayWidget = Image.file(
        _imageFile!,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    } else if (_currentImageBase64 != null && _currentImageBase64!.isNotEmpty) {
      try {
        Uint8List bytes = base64Decode(_currentImageBase64!);
        imageDisplayWidget = Image.memory(
          bytes,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/image-placeholder.png',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        imageDisplayWidget = Image.asset(
          'assets/image-placeholder.png',
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        );
      }
    } else {
      imageDisplayWidget = Image.asset(
        'assets/image-placeholder.png',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imageDisplayWidget,
        ),
        const SizedBox(height: 20),
        CustomButton(
          buttonText: 'UPLOAD IMAGE',
          onTap: _pickImage,
          color: Theme.of(context).colorScheme.secondary,
        ),
        if (_imageFile != null ||
            (_currentImageBase64 != null && _currentImageBase64!.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CustomButton(
              buttonText: 'REMOVE IMAGE',
              onTap: _clearImage,
              color: Colors.redAccent,
            ),
          ),
      ],
    );
  }
}
