import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plat_diseases_app/enums/image_source.dart';
import 'package:plat_diseases_app/functions/classifier.dart';

import 'image_source_selector.dart';

final getImage = FutureProvider<Map<String, String>>((ref) async {
  final ImagePicker picker = ImagePicker();

  XFile? file;

  final selected = ref.watch(selectedImageSource);

  switch (selected) {
    case ImageSourceSelector.camera:
      file = await picker.pickImage(
        source: ImageSource.camera,
      );
      break;
    case ImageSourceSelector.gallery:
      file = await picker.pickImage(
        source: ImageSource.gallery,
      );
      break;
  }
  CroppedFile? croppedFile;
  if (file != null) {
    croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true),
      ],
    );
  }
  if (croppedFile != null) {
    ///run the ml model
    final map = await ref.watch(classifire).run(image: croppedFile.path);

    return map;
  } else {
    return {};
  }
});
