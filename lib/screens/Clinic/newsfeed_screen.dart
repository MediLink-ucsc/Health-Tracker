import 'package:flutter/material.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';

class Post {
  final String doctor;
  final String content;
  final String? imageUrl; // optional image
  final DateTime createdAt;

  Post({
    required this.doctor,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });
}

class NewsFeedScreen extends StatelessWidget {
  NewsFeedScreen({super.key});

  final List<Post> _posts = [
    Post(
      doctor: 'Dr. Fernando',
      content: 'Remember to drink enough water today!',
      imageUrl: 'assets/drink.jpg', // placeholder image
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      doctor: 'Dr. Silva',
      content: 'Back pain can worsen if you lift heavy objects.',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Post(
      doctor: 'Dr. Kumara',
      content: 'Take a short walk after every meal to improve digestion.',
      imageUrl: 'assets/walk.jpg',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsfeed'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        appLogout(context);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: avatar + doctor name + time
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/doctor1.jpg'),
                      ),

                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.doctor,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${post.createdAt.toLocal()}'.split(
                              '.',
                            )[0], // simple timestamp
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Post content
                  Text(post.content, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 10),
                  // Post image
                  // Post image (supports network or local asset)
                  if (post.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: post.imageUrl!.startsWith('http')
                          ? Image.network(
                              post.imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              post.imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),

                  const SizedBox(height: 10),
                  // Action buttons (Like, Comment)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {},
                      ),
                    ],
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