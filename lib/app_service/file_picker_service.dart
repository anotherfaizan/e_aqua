import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<FilePickerResult?> pickFile({
    List<String>? allowedExtension,
    FileType? type,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type ?? FileType.any,
      allowedExtensions: allowedExtension,
    );

    if (result != null) {
      return result;
    } else {
      // User canceled the picker
      return null;
    }
  }

  static Future<FilePickerResult?> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      return result;
    } else {
      // User canceled the picker
      return null;
    }
  }
}
