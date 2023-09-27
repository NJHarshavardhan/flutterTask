import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photos_data.dart';
import 'helper.dart';

class ApiBaseHelper {
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return responseJson;
      case 400:
      //  throw BadRequestException(response.data.toString());
      case 401:
      case 403:
      //  throw UnAuthorisedException(response.data.toString());
      case 500:
      default:
    }
  }

  Map<String, String> getMainHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future<dynamic> get(String url) async {
    Helper().printMessage(url);
    var headers = getMainHeaders();
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      responseJson = _returnResponse(response);
    } catch (e) {
      Helper().printMessage(e.toString());
    }
    return responseJson;
  }
}

class ApiService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<PhotosData>> getPhotos() async {
    final response =
        await _helper.get("http://jsonplaceholder.typicode.com/photos");
    final List<dynamic> jsonResponse = json.decode(response);
    final List<PhotosData> photosDataList = jsonResponse
        .take(10)
        .map((json) => PhotosData.fromJson(json))
        .toList();
    return photosDataList;
  }
}
