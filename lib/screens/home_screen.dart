import 'package:flutter/material.dart';
import '../services/profile_manager.dart';
import 'mood_drop_screen.dart';
import 'chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for chats (limited to 2)
  final List<Map<String, String>> _chats = [
    {'name': 'Olivia', 'message': 'Sounds good!'},
    {'name': 'Daniel', 'message': 'What time?'},
  ];

  // Mock data for friend and family posts
  final List<Map<String, String>> _friendFamilyPosts = [
    {'name': 'Emily', 'post': 'Just finished my project! 🎉'},
    {'name': 'Mom', 'post': 'Hope you\'re having a great day! ❤️'},
  ];

  // Mock data for public clubs
  final List<Map<String, String>> _publicClubs = [
    {'name': 'City Club', 'activity': 'Jacob: Great weather!'},
    {'name': 'Writers Club', 'activity': 'New post'},
    {'name': 'Music Club', 'activity': 'Aria: Check this out!'},
  ];

  // Mood labels mapping
  final Map<String, String> _moodLabels = {
    '😊': 'Happy',
    '😌': 'Chill',
    '😇': 'Calm',
    '😰': 'Anxious',
    '😴': 'Tired',
    '😑': 'Bored',
    '🤩': 'Excited',
    '😒': 'Bored',
    '😢': 'Sad',
  };

  @override
  Widget build(BuildContext context) {
    final profile = ProfileManager().currentProfile;
    final userName = profile?.name ?? 'User';
    final userMood = profile?.mood ?? '😊';
    final moodLabel = _moodLabels[userMood] ?? 'Happy';

    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69), // Dark purple background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with mood display (left aligned)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MoodDropScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      userMood,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      moodLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Grid of cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  // Chats Card
                  _buildCard(
                    title: 'Chats',
                    icon: Icons.chat_bubble_outline,
                    color: const Color(0xFF74B9FF), // Light blue
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _chats
                            .map((chat) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        chat['message']!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    onTap: () {
                      // Navigate to chat list screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatListScreen(),
                        ),
                      );
                    },
                  ),

                  // Friend and Family Card
                  _buildCard(
                    title: 'Friend and Family',
                    icon: Icons.favorite_outline,
                    color: const Color(0xFF00B894), // Green
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _friendFamilyPosts
                            .map((post) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        post['post']!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to friend and family screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Friend and Family feature coming soon!')),
                      );
                    },
                  ),

                  // Public Clubs Card
                  _buildCard(
                    title: 'Public Clubs',
                    icon: Icons.public,
                    color: const Color(0xFFFFA500), // Orange
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _publicClubs
                            .map((club) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        club['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        club['activity']!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to public clubs screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Public Clubs feature coming soon!')),
                      );
                    },
                  ),

                  // Daily Buddy Card
                  _buildCard(
                    title: 'Daily Buddy',
                    icon: Icons.circle,
                    color: const Color(0xFFFFB6C1), // Light pink
                    content: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How was your day?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Last seen 10 m ago',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to daily buddy screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Daily Buddy feature coming soon!')),
                      );
                    },
                  ),

                  // Sam (AI) Card
                  _buildCard(
                    title: 'Sam',
                    icon: Icons.smart_toy,
                    color: const Color(0xFF74B9FF), // Light blue
                    content: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Talk to me!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to Sam AI chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Sam AI feature coming soon!')),
                      );
                    },
                  ),

                  // Profile Card
                  _buildCard(
                    title: 'Profile',
                    icon: Icons.person_outline,
                    color: const Color(0xFFDDA0DD), // Light purple
                    content: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit your profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to profile screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Content
                Expanded(
                  child: content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
