import 'package:dio/dio.dart';
import 'package:fe/api/api_client.dart';
import 'package:fe/interface/group/createGroupRequest.dart';

Future<void> createGroup(GroupRequest request) async {
  final api = ApiClient();

  final formData = FormData.fromMap({
    ...request.toJson(),
    if (request.imageBytes != null)
      "image": MultipartFile.fromBytes(
        request.imageBytes!,
        filename: "cover.jpg",
      ),
  });
  try {
    final response = await api.dio.post(
      "/groups",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  } on DioException catch (e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message']);
      }

      throw Exception("Group creation failed");
    } else {
      throw Exception("Network error");
    }
  }
}
