import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plat_diseases_app/enums/image_source.dart';
import 'package:plat_diseases_app/functions/image_source_selector.dart';
import 'package:plat_diseases_app/functions/pick_image.dart';
import 'package:plat_diseases_app/screens/result_page.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container( // Wrap Scaffold with Container
        color: Colors.black, // Set background color here
        child: Scaffold(
          appBar: AppBar(
            title: const Text('tomato_app_4233872'),
          ),
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(getImage);
                    ref.read(selectedImageSource.notifier).state =
                        ImageSourceSelector.camera;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResultPage(),
                      ),
                    );
                  },
                  child: const Text('Camera'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(getImage);
                    ref.read(selectedImageSource.notifier).state =
                        ImageSourceSelector.gallery;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResultPage(),
                      ),
                    );
                  },
                  child: const Text('Gallery'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
