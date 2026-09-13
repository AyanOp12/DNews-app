import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final dynamic article;

  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    String sourceName = (article['source_id'] ?? 'News').toString().toUpperCase();
    String content = article['content'] ?? article['description'] ?? 'No detailed content available for this news.';
    
    String pubDate = article['pubDate'] ?? '';
    String displayTime = pubDate;
    
    if (pubDate.isNotEmpty) {
      try {
        String isoFormatted = pubDate.replaceAll(' ', 'T') + 'Z';
        DateTime utcTime = DateTime.parse(isoFormatted);
        DateTime localTime = utcTime.toLocal(); 
        
        String dateOnly = '${localTime.year}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')}';
        int h = localTime.hour;
        int m = localTime.minute;
        String ampm = h >= 12 ? 'AM' : 'PM';
        
        if (h == 0) {
          h = 12;
        } else if (h > 12) {
          h -= 12;
        }
        
        String minStr = m.toString().padLeft(2, '0');
        displayTime = '$dateOnly  •  $h:$minStr $ampm';
      } catch (e) {
        displayTime = pubDate;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true, 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['image_url'] != null
                ? Image.network(
                    article['image_url'],
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[800],
                    child: const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sourceName,
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Text(
                    article['title'] ?? 'No Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 6),
                      Text(
                        displayTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey, height: 40, thickness: 0.5),
                  
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6, 
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}