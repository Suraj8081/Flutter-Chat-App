import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

void moveTo(BuildContext context, Widget nextScreen,
    {bool clearRoute = false}) {
  dev.log('Navigate to => $nextScreen');
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (ctx) => nextScreen),
    (route) => !clearRoute,
  );
}

ColorScheme getThemeColor(BuildContext context) {
  return Theme.of(context).colorScheme;
}

void showImagePicker(
    BuildContext context, Function(File? selectedFile) selectedFile) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext bc) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: getThemeColor(context).primary,
            ),
            title: const Text('Photo Library'),
            onTap: () {
              _getImage(ImageSource.gallery, selectedFile);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.photo_camera,
              color: getThemeColor(context).primary,
            ),
            title: const Text('Camera'),
            onTap: () {
              _getImage(ImageSource.camera, selectedFile);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: getThemeColor(context).primary,
            ),
            title: const Text('Remove Image'),
            onTap: () {
              selectedFile(null);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      );
    },
  );
}

void _getImage(ImageSource source, Function(File?) selectedFile) async {
  final XFile? pickedFile = await _picker.pickImage(source: source);
  final File? file = pickedFile != null ? File(pickedFile.path) : null;
  selectedFile(file);
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
    ),
  );
}
