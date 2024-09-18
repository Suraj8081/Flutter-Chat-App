import 'dart:developer' as dev;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

void moveTo(BuildContext context, Widget nextScreen,
    {bool clearRoute = false}) {
  dev.log('Navigate to => $nextScreen');
  if (clearRoute) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => nextScreen,
      ),
      (route) => !clearRoute,
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => nextScreen,
      ),
    );
  }
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
              pickImage(ImageSource.gallery, selectedFile);
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
              pickImage(ImageSource.camera, selectedFile);
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

void pickImage(ImageSource source, Function(File?) selectedFile) async {
  final XFile? pickedFile =
      await _picker.pickImage(source: source, imageQuality: 30);
  final File? file = pickedFile != null ? File(pickedFile.path) : null;
  selectedFile(file);
}

void showSnackBar(BuildContext context, String title,
    {Color? bgColor, Color? txtColor}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
        style: TextStyle(color: txtColor),
      ),
      backgroundColor: bgColor,
      showCloseIcon: true,
    ),
  );
}

void pickFile(Function(List<File> file) selectedFile,
    {bool multipleSelection = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: multipleSelection,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc'],
  );

  if (result != null) {
    List<File> files = result.paths.map((path) => File(path!)).toList();
    selectedFile(files);
  } else {
    print("No file selected");
  }
}
