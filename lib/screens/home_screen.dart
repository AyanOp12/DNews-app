import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          // লিডিং আইকন সরিয়ে এখানে লোগো এবং নাম একসাথে দেওয়া হলো
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.language, color: Colors.blueAccent, size: 24),
              ),
              const SizedBox(width: 10),
              const Text(
                'D News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
            labelColor: Colors.white, 
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white, 
            dividerColor: Colors.transparent, 
            tabs: [
              Tab(text: 'All News'),
              Tab(text: 'Sports'),
              Tab(text: 'Technology'),
              Tab(text: 'Entertainment'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewsListTab(category: 'top'), 
            NewsListTab(category: 'sports'),
            NewsListTab(category: 'technology'),
            NewsListTab(category: 'entertainment'),
          ],
        ),
      ),
    );
  }
}

class NewsListTab extends StatefulWidget {
  final String category;
  const NewsListTab({super.key, required this.category});

  @override
  State<NewsListTab> createState() => _NewsListTabState();
}

class _NewsListTabState extends State<NewsListTab> {
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _articles = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _nextPage; // NewsData-তে পেজ টোকেন স্ট্রিং হয়

  @override
  void initState() {
    super.initState();
    _fetchNews(); 
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _fetchNews();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNews() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    String apiKey = "pub_7d530b25c89044088646737eb27227f1"; 
    String url = "https://newsdata.io/api/1/latest?apikey=$apiKey&language=en&country=in";
    
    if (widget.category != 'top') {
      url += "&category=${widget.category}";
    }
    if (_nextPage != null) {
      url += "&page=$_nextPage";
    }

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        var newArticles = response.data['results'] ?? [];
        String? nextPageToken = response.data['nextPage'];

        setState(() {
          _articles.addAll(newArticles);
          _nextPage = nextPageToken;
          if (nextPageToken == null) {
            _hasMore = false;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _articles.clear();
      _nextPage = null;
      _hasMore = true;
    });
    await _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    if (_articles.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_articles.isEmpty && !_isLoading) {
      return const Center(child: Text('No news found', style: TextStyle(color: Colors.white)));
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.black,
      backgroundColor: Colors.white,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _articles.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }

          var article = _articles[index];
          if (article['title'] == null) return const SizedBox.shrink(); 

          String sourceName = (article['source_id'] ?? 'News').toString().toUpperCase();
          if (sourceName.length > 10) {
            sourceName = '${sourceName.substring(0, 9)}..';
          }

          String pubDate = article['pubDate'] ?? '';
          String dateOnly = '';
          String timeAmPm = '';

          if (pubDate.isNotEmpty) {
            try {
              String isoFormatted = pubDate.replaceAll(' ', 'T') + 'Z';
              DateTime utcTime = DateTime.parse(isoFormatted);
              DateTime localTime = utcTime.toLocal(); 

              dateOnly = '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')}';
              
              int h = localTime.hour;
              int m = localTime.minute;
              String ampm = h >= 12 ? 'AM' : 'PM';
              
              if (h == 0) {
                h = 12;
              } else if (h > 12) {
                h -= 12;
              }
              
              String minStr = m.toString().padLeft(2, '0');
              timeAmPm = '$h:$minStr $ampm';
            } catch (e) {
              if (pubDate.length >= 10) dateOnly = pubDate.substring(0, 10);
              if (pubDate.length >= 16) timeAmPm = pubDate.substring(11, 16);
            }
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(article: article)),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), 
                borderRadius: BorderRadius.circular(16), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12), 
                    child: article['image_url'] != null
                        ? Image.network(
                            article['image_url'],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 90, height: 90, color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 90, height: 90, color: Colors.grey[800],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                            color: Colors.white 
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.newspaper, size: 12, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Text(
                                    sourceName, 
                                    style: TextStyle(color: Colors.blue[300], fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.calendar_today, size: 10, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateOnly,
                                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              timeAmPm,
                              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}