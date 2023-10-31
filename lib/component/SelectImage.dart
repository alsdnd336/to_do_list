import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage extends StatelessWidget {
  const SelectImage({required this.camera, required this.gallery, super.key});
  final Function() camera;
  final Function() gallery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            onTap: camera,
            leading: const Icon(Icons.camera_alt, color: Colors.black,),
            title: const Text('카메라로 촬영', style: TextStyle(color: Colors.black, fontSize: 20),),),
          const Divider(color: Colors.grey, thickness: 1,),
          ListTile(
            onTap: gallery,
            leading: const Icon(Icons.image, color: Colors.black,),
            title: const Text('갤러리에서 선택', style: TextStyle(color: Colors.black, fontSize: 20),),
          ),
        ],
      ),
    );
  }
}