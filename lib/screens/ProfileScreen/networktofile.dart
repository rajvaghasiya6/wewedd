import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../general/string_constants.dart';

Future<File> fileFromImageUrl(String url) async {
  final response = await http.get(Uri.parse(StringConstants.apiUrl + url));

  final documentDirectory = await getApplicationDocumentsDirectory();

  final file = File(join(
      documentDirectory.path, 'image_cropper_' + getRandomString(13) + '.jpg'));

  file.writeAsBytesSync(response.bodyBytes);

  return file;
}

const _chars = '1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
