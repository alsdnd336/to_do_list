import 'package:flutter/cupertino.dart';

class thumbnailImageProvider extends ChangeNotifier {
  
  String? thumbnailPath;

  void setThumbnailPath(String path) {
    thumbnailPath = path;
    notifyListeners();
  }
}