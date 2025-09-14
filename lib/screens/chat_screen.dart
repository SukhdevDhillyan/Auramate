import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String chatName;
  final String chatId;

  const ChatScreen({
    super.key,
    required this.chatName,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isRecording = false;
  bool _showStickers = false;
  bool _showMediaOptions = false;
  Timer? _typingTimer;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadMockMessages();

    // Listen to focus changes to handle keyboard behavior
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        // When keyboard appears, ensure latest messages are visible
        _handleKeyboardAppearance();
      }
    });

    // Listen to text changes to update UI
    _messageController.addListener(() {
      setState(() {
        // This will trigger a rebuild to show/hide send button
      });
    });

    // With reverse: true ListView, latest messages will be shown by default
  }

  void _handleKeyboardAppearance() {
    // With reverse: true, ensure we stay at the top (latest messages)
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom(animate: false);
    });
  }

  void _loadMockMessages() {
    // Mock messages for demonstration
    _messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Are you coming?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        senderName: widget.chatName,
        type: MessageType.text,
      ),
      ChatMessage(
        id: '2',
        text: 'Yes, I\'ll be there! 😊',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        senderName: 'You',
        type: MessageType.text,
      ),
      ChatMessage(
        id: '3',
        text: '',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        senderName: widget.chatName,
        type: MessageType.sticker,
        stickerId: 'happy_dance',
      ),
      ChatMessage(
        id: '4',
        text: 'Feeling good today',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        senderName: widget.chatName,
        type: MessageType.text,
      ),
      ChatMessage(
        id: '5',
        text: '',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        senderName: 'You',
        type: MessageType.image,
        mediaUrl: 'https://picsum.photos/300/200',
      ),
      ChatMessage(
        id: '6',
        text: 'Looks great! 👀👀',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        senderName: 'You',
        type: MessageType.text,
      ),
    ]);

    // Sort messages by timestamp
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      type: MessageType.text,
    );

    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
    _sortMessages();

    // Dismiss keyboard and return to full screen view
    _messageFocusNode.unfocus();

    // With reverse: true, new messages appear at the top automatically

    // Simulate a reply after a short delay
    _simulateReply();
  }

  void _sendSticker(String stickerId) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isMe: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      type: MessageType.sticker,
      stickerId: stickerId,
    );

    setState(() {
      _messages.add(message);
      _showStickers = false;
    });

    _sortMessages();
  }

  void _sendImage() {
    // Simulate image picker
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Photo',
      isMe: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      type: MessageType.image,
      mediaUrl:
          'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      _messages.add(message);
      _showMediaOptions = false;
    });

    _sortMessages();
  }

  void _sendVideo() {
    // Simulate video picker
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Video',
      isMe: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      type: MessageType.video,
      mediaUrl:
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    );

    setState(() {
      _messages.add(message);
      _showMediaOptions = false;
    });

    _sortMessages();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });

    // Simulate recording for 3 seconds
    Timer(const Duration(seconds: 3), () {
      _stopRecording();
    });
  }

  void _stopRecording() {
    if (_recordingTimer != null) {
      _recordingTimer!.cancel();
    }

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Voice message',
      isMe: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      type: MessageType.voice,
      voiceDuration: _recordingDuration,
    );

    setState(() {
      _isRecording = false;
      _messages.add(message);
    });

    _sortMessages();
  }

  void _sortMessages() {
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _onTextChanged(String text) {
    // Update UI to show/hide send button
    setState(() {
      // This will trigger a rebuild to show/hide send button
    });
  }

  void _simulateReply() {
    // Show typing indicator for the other person
    setState(() {
      _isTyping = true;
    });

    // Hide typing indicator and send reply after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });

        final replies = [
          'That sounds amazing!',
          'I totally agree with you',
          'Thanks for sharing that!',
          'That\'s really cool!',
          'I\'m so happy for you!',
          'That makes perfect sense',
        ];

        final randomReply = replies[Random().nextInt(replies.length)];
        final reply = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: randomReply,
          isMe: false,
          timestamp: DateTime.now(),
          senderName: widget.chatName,
        );

        setState(() {
          _messages.add(reply);
        });
      }
    });
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // With reverse: true, maxScrollExtent is at the top (latest messages)
        if (animate) {
          _scrollController.animateTo(
            0.0, // Scroll to top for latest messages with reverse: true
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          // Immediate scroll without animation
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingTimer?.cancel();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
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
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    widget.chatName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // TODO: Show chat options
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse:
                      true, // This will naturally show latest messages at bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    // Reverse the index to show latest messages first
                    final message = _messages[_messages.length - 1 - index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),

              // Typing indicator
              if (_isTyping)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          widget.chatName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.chatName} is typing...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

              // Stickers panel
              if (_showStickers)
                Container(
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Stickers',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _showStickers = false),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _getStickers().length,
                          itemBuilder: (context, index) {
                            final sticker = _getStickers()[index];
                            return GestureDetector(
                              onTap: () => _sendSticker(sticker['id'] ?? ''),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    sticker['emoji'] ?? '😊',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Media options panel
              if (_showMediaOptions)
                Container(
                  height: 120,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMediaOption(
                          Icons.photo_camera, 'Camera', _sendImage),
                      _buildMediaOption(
                          Icons.photo_library, 'Gallery', _sendImage),
                      _buildMediaOption(Icons.videocam, 'Video', _sendVideo),
                      _buildMediaOption(Icons.mic, 'Voice', _startRecording),
                      _buildMediaOption(Icons.emoji_emotions, 'Stickers', () {
                        setState(() {
                          _showMediaOptions = false;
                          _showStickers = true;
                        });
                      }),
                    ],
                  ),
                ),

              // Message input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Plus button (for media options)
                    GestureDetector(
                      onTap: () => setState(
                          () => _showMediaOptions = !_showMediaOptions),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          style: const TextStyle(color: Colors.black),
                          onChanged: _onTextChanged,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            suffixIcon: _messageController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: _sendMessage,
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6C5CE7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => setState(
                                        () => _showStickers = !_showStickers),
                                    child: Icon(
                                      Icons.emoji_emotions,
                                      color: Colors.grey.withOpacity(0.7),
                                      size: 20,
                                    ),
                                  ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    // Show camera and mic buttons only when not typing
                    if (_messageController.text.isEmpty) ...[
                      const SizedBox(width: 12),
                      // Camera button
                      GestureDetector(
                        onTap: _sendImage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Microphone button
                      GestureDetector(
                        onTap: _startRecording,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.mic,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getStickers() {
    return [
      {'id': 'happy_dance', 'emoji': '🐻'}, // Bear waving
      {'id': 'love_heart', 'emoji': '💕'},
      {'id': 'laughing', 'emoji': '😂'},
      {'id': 'thumbs_up', 'emoji': '👍'},
      {'id': 'fire', 'emoji': '🔥'},
      {'id': 'party', 'emoji': '🎉'},
      {'id': 'thinking', 'emoji': '🤔'},
      {'id': 'wink', 'emoji': '😉'},
      {'id': 'cool', 'emoji': '😎'},
      {'id': 'heart_eyes', 'emoji': '😍'},
      {'id': 'crying', 'emoji': '😭'},
      {'id': 'angry', 'emoji': '😡'},
      {'id': 'sleepy', 'emoji': '😴'},
      {'id': 'surprised', 'emoji': '😮'},
      {'id': 'confused', 'emoji': '😕'},
      {'id': 'celebrate', 'emoji': '🎊'},
    ];
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // For stickers and images, show without bubble container
    if (message.type == MessageType.sticker ||
        message.type == MessageType.image) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  message.senderName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(message),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (message.isMe) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // For text messages, show with bubble container
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? const Color(
                        0xFFFFEB3B) // Bright yellow for outgoing messages
                    : Colors.white, // White for incoming messages
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 20),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(message),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                      if (message.reactions.isNotEmpty)
                        Row(
                          children: message.reactions.map((reaction) {
                            return Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                reaction,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.3,
          ),
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF87CEEB), // Sky blue
                      Color(0xFF90EE90), // Light green
                      Color(0xFF228B22), // Forest green
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Tree trunks
                    Positioned(
                      left: 20,
                      bottom: 0,
                      child: Container(
                        width: 8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      bottom: 0,
                      child: Container(
                        width: 8,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      bottom: 0,
                      child: Container(
                        width: 8,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Tree canopies
                    Positioned(
                      left: 10,
                      top: 20,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFF228B22),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      top: 10,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Color(0xFF228B22),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 15,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF228B22),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Sun
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.black,
                      size: 50,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.videocam,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case MessageType.voice:
        return Row(
          children: [
            Icon(
              _isRecording ? Icons.stop : Icons.play_arrow,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.6, // Simulate progress
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${message.voiceDuration}s',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        );

      case MessageType.sticker:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                _getStickerEmoji(message.stickerId ?? ''),
                style: const TextStyle(fontSize: 48),
              ),
              if (message.stickerId == 'happy_dance')
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Text(
                    'HELLO',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );

      default:
        return Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.3,
          ),
        );
    }
  }

  String _getStickerEmoji(String stickerId) {
    final stickers = _getStickers();
    final sticker = stickers.firstWhere(
      (s) => s['id'] == stickerId,
      orElse: () => {'id': '', 'emoji': '😊'},
    );
    return sticker['emoji'] ?? '😊';
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

enum MessageType { text, image, video, voice, sticker, reaction }

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String senderName;
  final MessageType type;
  final String? mediaUrl;
  final int? voiceDuration;
  final String? stickerId;
  final List<String> reactions;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.senderName,
    this.type = MessageType.text,
    this.mediaUrl,
    this.voiceDuration,
    this.stickerId,
    this.reactions = const [],
  });
}
