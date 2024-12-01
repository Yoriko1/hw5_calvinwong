import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://opentdb.com";

  // Fetch categories
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api_category.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['trivia_categories'];
    } else {
      throw Exception("Failed to load categories");
    }
  }

  // Fetch questions
  static Future<List<dynamic>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    final url =
        '$baseUrl/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=$type';
    print('Fetching questions from URL: $url'); // Debug the API URL

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('API Response: $data'); // Debug the API response

      if (data['response_code'] == 0) {
        return data['results'];
      } else {
        print('API returned response_code: ${data['response_code']}');
        return [];
      }
    } else {
      print('API request failed with status: ${response.statusCode}');
      throw Exception("Failed to load questions");
    }
  }
}
