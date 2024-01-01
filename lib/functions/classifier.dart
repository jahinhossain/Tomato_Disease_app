import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

final classifire = StateProvider<Classifier>((ref) => Classifier());

class Classifier {
  Future<Map<String, String>> run({required String image}) async {
    ///prepare image to feed in to the classifire
    ///change the [224] to match with your new models input size.
    final imageInput = File(image);
    final decodedImage = img.decodeImage(await imageInput.readAsBytes());
    final resizedImage = img.copyResize(
      decodedImage!,
      width: 224,
      height: 224,
    );

    ///change the [224] to match with your new models input size.
    final imageBuffer =
        await _imageToByteListFloat32(resizedImage, 224, 127.5, 127.5);

    ///loading the tensorflow model
    final interpreter = await tfl.Interpreter.fromAsset(
      'assets/model/model.tflite',
      options: tfl.InterpreterOptions()..threads = 4,
    );

    ///preparing the output to match the output of the ML model
    ///Make sure to have a matching output
    var output0 = [List.filled(11, 0.0)];
    Map<int, Object> output = {0: output0};

    ///running the ML on input image
    interpreter.runForMultipleInputs([imageBuffer.buffer], output);

    final results = output[0] as List<List<double>>;

    ///load labels
    final List<String> labels = await _loadLabels();

    final maxValue = results[0].reduce(max);
    final maxIndex = results[0].indexOf(maxValue);

    final Map<String, String> resultMap = {
      'image': image,
      'label': labels[maxIndex],
      'confidence': maxValue.toString(),
    };

    ///closing the interpreter
    interpreter.close();
    return resultMap;
  }

  ///this function helps to decode image into UintBytes. This will be the input buffer of the ML model.
  Future<Uint8List> _imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) async {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }

    return convertedBytes.buffer.asUint8List();
  }

  ///loading labels
  Future<List<String>> _loadLabels() async {
    final labelTxt = await rootBundle.loadString('assets/model/labels.txt');
    final List<String> labels = labelTxt.split('\n');
    return labels;
  }
}
