import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AzureApi {
  Future<String> makeGptApiCall(
      {required String userContent, required String prompt}) async {
    try {
      const String url =
          'https://wizskillsai.openai.azure.com/openai/deployments/deplymentgpt/chat/completions?api-version=2024-02-15-preview';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'api-key': 'c6ec9e339bc94ce382c0163f476c7412',
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
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        // Extracting the content from the response

        String content = jsonResponse['choices'][0]['message']['content'];
        return content;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("ERROR getting GPT : ${e.toString()}");
      rethrow;
    }
  }

  Future<String> makeWhisperApiCall(
      {required String recordedUrl}) async {
    try {
      // Check if the file exists at the specified path

      // Rest of your code remains unchanged
      // Construct the API URL
      const String endpoint = 'https://wizskillsai.openai.azure.com';
      const String apiKey = 'c6ec9e339bc94ce382c0163f476c7412';
      const String deploymentName = 'deployment-01';
      const String apiUrl =
          '$endpoint/openai/deployments/$deploymentName/audio/transcriptions?api-version=2024-02-01';
      final Uri url = Uri.parse(apiUrl);

      final http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', recordedUrl));
      request.headers['api-key'] = apiKey;

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseData = await response.stream.bytesToString();
        return json.decode(responseData)['text'];
      } else {
        return ('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making whisper API call: $e');
      // You may want to throw the error here to propagate it
      rethrow;
    }
    // Add a default return statement
  }
}
