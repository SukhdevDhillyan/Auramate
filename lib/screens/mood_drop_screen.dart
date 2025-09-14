import 'package:flutter/material.dart';
import '../services/profile_manager.dart';
import 'home_screen.dart';

class MoodDropScreen extends StatefulWidget {
  const MoodDropScreen({super.key});

  @override
  State<MoodDropScreen> createState() => _MoodDropScreenState();
}

class _MoodDropScreenState extends State<MoodDropScreen> {
  String? _selectedMood;
  bool _isLoading = false;

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Chill'},
    {'emoji': '😇', 'label': 'Calm'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😑', 'label': 'Bored'},
    {'emoji': '🤩', 'label': 'Excited'},
    {'emoji': '😒', 'label': 'Bored'},
    {'emoji': '😢', 'label': 'Sad'},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingMood();
  }

  void _loadExistingMood() {
    final profile = ProfileManager().currentProfile;
    if (profile?.mood != null) {
      setState(() {
        _selectedMood = profile!.mood;
      });
    }
  }

  void _selectMood(String mood) async {
    setState(() {
      _selectedMood = mood;
      _isLoading = true;
    });

    // Update profile with selected mood
    ProfileManager().updateMood(mood);

    // Simulate saving mood to backend
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
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
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 61, 21, 156), // Purple
              Color.fromARGB(255, 255, 87, 34), // Orange-red
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Select your mood',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Mood Grid (3x3)
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: _moods.length,
                    itemBuilder: (context, index) {
                      final mood = _moods[index];
                      final isSelected = _selectedMood == mood['emoji'];

                      return GestureDetector(
                        onTap: () => _selectMood(mood['emoji']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Emoji
                              Text(
                                mood['emoji']!,
                                style: TextStyle(
                                  fontSize: isSelected ? 40 : 36,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Label
                              Text(
                                mood['label']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Loading indicator when mood is being saved
                if (_isLoading) ...[
                  const SizedBox(height: 40),
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
