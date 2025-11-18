import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '../ui/result_page.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  File? get imageFile => _imageFile;

  /// --- Ambil gambar dari galeri ---
  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path); // gambar dari galeri
      await _cropImage(_imageFile!); // gambarnya di crop
    }
    notifyListeners();
  }

  /// --- Ambil gambar langsung dari kamera ---
  Future<void> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _imageFile = File(image.path);
      await _cropImage(_imageFile!);
    }
    notifyListeners();
  }

  // fungsi crop image
  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Color(0xff00a572),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      _imageFile = File(croppedFile.path);
      notifyListeners();
    }
  }

  /// --- Hapus gambar yang sudah diupload/crop ---
  void removeImage() {
    _imageFile = null;
    notifyListeners();
  }

  void goToResultPage(BuildContext context) {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage()),
      );
    }
  }
}
