import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatItem> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadMockChats();
  }

  void _loadMockChats() {
    _chats.addAll([
      ChatItem(
        id: 'riya_chat',
        name: 'Riya',
        profilePicture: '👩',
        mood: '😊',
        lastMessage: 'Are you coming?',
        timestamp: '2:34 PM',
        unreadCount: 1,
        isOnline: true,
      ),
      ChatItem(
        id: 'arjun_chat',
        name: 'Arjun',
        profilePicture: '👨',
        mood: '😎',
        lastMessage: 'Check this out 👀',
        timestamp: '1:12 PM',
        unreadCount: 0,
        isOnline: true,
      ),
      ChatItem(
        id: 'mehul_chat',
        name: 'Mehul',
        profilePicture: '👩',
        mood: '🥺',
        lastMessage: 'Feeling low today...',
        timestamp: '11:05 AM',
        unreadCount: 0,
        isOnline: false,
      ),
      ChatItem(
        id: 'neha_chat',
        name: 'Neha',
        profilePicture: '👩',
        mood: '😍',
        lastMessage: 'I had a great time 😊',
        timestamp: '9:27 AM',
        unreadCount: 0,
        isOnline: true,
      ),
      ChatItem(
        id: 'sanya_chat',
        name: 'Sanya',
        profilePicture: '👩',
        mood: '🙂',
        lastMessage: 'Okay, I will let you know',
        timestamp: 'Today',
        unreadCount: 0,
        isOnline: false,
      ),
      ChatItem(
        id: 'aman_chat',
        name: 'Aman',
        profilePicture: '👨',
        mood: '😁',
        lastMessage: 'Ping me when free!',
        timestamp: 'Today',
        unreadCount: 0,
        isOnline: true,
      ),
      ChatItem(
        id: 'pooja_chat',
        name: 'Pooja',
        profilePicture: '👩',
        mood: '😡',
        lastMessage: 'No way!',
        timestamp: 'Today',
        unreadCount: 0,
        isOnline: false,
      ),
      ChatItem(
        id: 'vishal_chat',
        name: 'Vishal',
        profilePicture: '👨',
        mood: '😊',
        lastMessage: 'Good night!',
        timestamp: 'Sunday',
        unreadCount: 0,
        isOnline: false,
      ),
    ]);
  }

  void _openChat(ChatItem chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatName: chat.name,
          chatId: chat.id,
        ),
      ),
    );
  }

  void _startNewChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FriendsListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 61, 21, 156),
              Color.fromARGB(255, 131, 81, 217),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Chats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];
              return _buildChatItem(chat);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _startNewChat,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return InkWell(
      onTap: () => _openChat(chat),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getProfileColor(chat.name),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      chat.profilePicture,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chat.mood,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Timestamp and Unread Count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                if (chat.unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProfileColor(String name) {
    // Generate consistent colors based on name
    final colors = [
      const Color(0xFF74B9FF), // Light blue
      const Color(0xFF00B894), // Teal
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFFB6C1), // Light pink
      const Color(0xFFDDA0DD), // Light purple
      const Color(0xFF98D8C8), // Mint green
      const Color(0xFFFFEAA7), // Light yellow
      const Color(0xFFDDA0DD), // Lavender
    ];

    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final List<Friend> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadMockFriends();
  }

  void _loadMockFriends() {
    _friends.addAll([
      Friend(
        id: 'friend_1',
        name: 'Alex Johnson',
        profilePicture: '👨',
        mood: '😊',
        isOnline: true,
        lastSeen: 'Online',
      ),
      Friend(
        id: 'friend_2',
        name: 'Sarah Wilson',
        profilePicture: '👩',
        mood: '😍',
        isOnline: true,
        lastSeen: 'Online',
      ),
      Friend(
        id: 'friend_3',
        name: 'Mike Chen',
        profilePicture: '👨',
        mood: '😎',
        isOnline: false,
        lastSeen: '2 hours ago',
      ),
      Friend(
        id: 'friend_4',
        name: 'Emma Davis',
        profilePicture: '👩',
        mood: '🥺',
        isOnline: true,
        lastSeen: 'Online',
      ),
      Friend(
        id: 'friend_5',
        name: 'David Brown',
        profilePicture: '👨',
        mood: '😁',
        isOnline: false,
        lastSeen: '1 day ago',
      ),
      Friend(
        id: 'friend_6',
        name: 'Lisa Garcia',
        profilePicture: '👩',
        mood: '🙂',
        isOnline: true,
        lastSeen: 'Online',
      ),
      Friend(
        id: 'friend_7',
        name: 'Tom Anderson',
        profilePicture: '👨',
        mood: '😡',
        isOnline: false,
        lastSeen: '3 hours ago',
      ),
      Friend(
        id: 'friend_8',
        name: 'Kate Miller',
        profilePicture: '👩',
        mood: '😊',
        isOnline: true,
        lastSeen: 'Online',
      ),
    ]);
  }

  void _startChatWithFriend(Friend friend) {
    Navigator.of(context).pop(); // Go back to chat list
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatName: friend.name,
          chatId: friend.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 61, 21, 156),
              Color.fromARGB(255, 131, 81, 217),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Start New Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              // Friends list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _friends.length,
                  itemBuilder: (context, index) {
                    final friend = _friends[index];
                    return _buildFriendItem(friend);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendItem(Friend friend) {
    return InkWell(
      onTap: () => _startChatWithFriend(friend),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getProfileColor(friend.name),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      friend.profilePicture,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                if (friend.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Friend Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        friend.mood,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend.isOnline ? 'Online' : friend.lastSeen,
                    style: TextStyle(
                      fontSize: 14,
                      color: friend.isOnline
                          ? Colors.green.withOpacity(0.8)
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Chat button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.chat,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProfileColor(String name) {
    // Generate consistent colors based on name
    final colors = [
      const Color(0xFF74B9FF), // Light blue
      const Color(0xFF00B894), // Teal
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFFB6C1), // Light pink
      const Color(0xFFDDA0DD), // Light purple
      const Color(0xFF98D8C8), // Mint green
      const Color(0xFFFFEAA7), // Light yellow
      const Color(0xFFDDA0DD), // Lavender
    ];

    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}

class ChatItem {
  final String id;
  final String name;
  final String profilePicture;
  final String mood;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;

  ChatItem({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.mood,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
  });
}

class Friend {
  final String id;
  final String name;
  final String profilePicture;
  final String mood;
  final bool isOnline;
  final String lastSeen;

  Friend({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.mood,
    required this.isOnline,
    required this.lastSeen,
  });
}
