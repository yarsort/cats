import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:translator/translator.dart';
import 'package:hive/hive.dart';

import '../system/constants.dart';

part 'fact.g.dart';

@HiveType(typeId: 0)
class Fact extends HiveObject {

  @HiveField(0)
  final int id; //	ObjectId 	Unique ID for the Fact

  @HiveField(1)
  final String text; 	//The Fact itself

  @HiveField(2)
  final String imagePath; 	//The Fact itself

  @HiveField(3)
  late DateTime period; 	//The Fact itself

  Fact({
    required this.id,
    required this.text,
    required this.imagePath,
    required this.period,
  });

  @override
  List<Object?> get props => [id, text, imagePath, period];

  static Box<Fact> getHiveBoxFacts() {
    return Hive.box<Fact>('facts');
  }

  static Future<String> getFactImage() async {
    String nameFile = '';

    var response = await http.get(Uri.parse('https://cataas.com/cat'),
        headers: {});

    if (response.statusCode == 200) {

      // Set local file parameters
      final appDir = await getTemporaryDirectory();

      List<FileSystemEntity> files = appDir.listSync();
      for (var file in files){
        final extension = path.extension(file.path);
        if (extension == 'jpg'){
          file.deleteSync();
        }
      }

      // Incrementing
      countingImagePath++;
      // Create new file name for errors with caching
      nameFile = path.join(appDir.path, 'picture${countingImagePath.toString()}.jpg');
      // Downloading and saving data to local file
      final imageFile = File(nameFile);
      await imageFile.writeAsBytes(response.bodyBytes);
    }
    print('Name file: $nameFile');
    return nameFile;
  }

  static Future<String> translateFact(text) async {
    final translator = GoogleTranslator();
    final input = text;

    var translation = await translator
        .translate(input, from: 'en', to: 'uk');

    return translation.text;
  }


}