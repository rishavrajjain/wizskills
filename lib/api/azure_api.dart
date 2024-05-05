import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wizskills/api/api_end_points.dart';

class AzureApi {
  Future<String> makeGptApiCall(
      {required String userContent, required String prompt}) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'api-key': ApiEndpoints.gptApiKey,
      };
      final Map<String, dynamic> data = {
        "messages": [
          {"role": "system", "content": prompt},
          {"role": "user", "content": userContent}
        ],
        "max_tokens": 800,
        "temperature": 0.5,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "top_p": 0.95,
        "stop": null
      };

      final http.Response response = await http.post(
        Uri.parse(ApiEndpoints.gptApiUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String content = jsonResponse['choices'][0]['message']['content'];
        return content;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("ERROR getting GPT Text : ${e.toString()}");
      rethrow;
    }
  }

  Future<String> makeWhisperApiCall(
      {required String recordedUrl}) async {
    try {
      final Uri url = Uri.parse(ApiEndpoints.whisperApiUrl);
      final http.MultipartRequest request =
          http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
          'file', recordedUrl));
      request.headers['api-key'] = ApiEndpoints.whisperApiKey;

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseData = await response.stream.bytesToString();
        return json.decode(responseData)['text'];
      } else {
        return ('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making whisper API call: $e');
      rethrow;
    }
  }
}
