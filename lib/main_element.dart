import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MainElementScreen extends StatefulWidget {
  @override
  _MainElementScreenState createState() => _MainElementScreenState();
}

class _MainElementScreenState extends State<MainElementScreen> {
  bool isLoading = true;
  List<dynamic> news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/everything?q=Real Madrid&apiKey=b432bcda80c044adae12ee7079a87817'), 
    );
    if (response.statusCode == 200) {
      setState(() {
        news = json.decode(response.body)['articles'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dernières nouvelles'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(article: news[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          news[index]['urlToImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/news_placeholder.png',
                                    image: news[index]['urlToImage'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/news_placeholder.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/news_placeholder.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news[index]['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  news[index]['description'] ?? 'No description available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic article;

  DetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail de l article'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                article['urlToImage'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/news_placeholder.png',
                          image: article['urlToImage'],
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/news_placeholder.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/news_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(height: 16),
                Text(
                  article['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'By ${article['author'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  article['publishedAt'] != null
                      ? 'Published at ${article['publishedAt']}'
                      : 'Publication date not available',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Text(
                  article['content'] ?? 'Content not available',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = article['url'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: Text('En savoir plus'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}