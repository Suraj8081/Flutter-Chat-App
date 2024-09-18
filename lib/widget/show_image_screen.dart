import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getThemeColor(context).primary,
        title: Text(
          'Image',
          style: TextStyle(
              color: getThemeColor(context).onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: WidgetZoom(
          heroAnimationTag: imageUrl,
          zoomWidget: Image.network(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
