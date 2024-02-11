import 'package:http/http.dart' as http;

class NewsApi {
  final String country;
  final String token;
  Uri url = Uri.http('');

  NewsApi(this.country, this.token) {
    url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$token');
  }

  Future getNewsTop() async {
    var response = await http.get(url);
    return response;
  }

  void fetchNews(callback) {
    getNewsTop().then(callback);
  }
}
