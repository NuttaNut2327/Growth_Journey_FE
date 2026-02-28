import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<String?> getUserId() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  if (token == null) return null;

  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

  return decodedToken['user_id'];
}