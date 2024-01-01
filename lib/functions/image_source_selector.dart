import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plat_diseases_app/enums/image_source.dart';

final selectedImageSource =
    StateProvider<ImageSourceSelector>((ref) => ImageSourceSelector.gallery);
