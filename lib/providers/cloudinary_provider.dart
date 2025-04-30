import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Clase para la gestión de peticiones hacía nuestra nube en Cloudinary para guardar imagenes
class CloudinaryProvider {
  static const String _cloudName = 'djmppajod';
  static const String _uploadPreset = 'flutter';

  // Subir imagen
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return data['secure_url'];
      } else {
        print('Error en Cloudinary: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al subir a Cloudinary: $e');
      return null;
    }
  }
}
