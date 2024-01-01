import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plat_diseases_app/functions/pick_image.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Result",
          ),
        ),
        body: ref.watch(getImage).when(data: (data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: Image.file(
                      File(
                        data['image']!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Identified Diseases: ${data['label']}",
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // Text(
                //   "Confidence: ${(double.parse(data['confidence']!) * 100).toStringAsFixed(2)}%",
                // ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        }, error: (error, stack) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
