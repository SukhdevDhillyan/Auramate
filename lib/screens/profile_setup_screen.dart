import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../widgets/logo.dart';
import '../config/places_config.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();

  File? _profileImage;
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoadingLocation = false;
  bool _isLoading = false;
  bool _isCityFieldFocused = false;
  List<String> _filteredCities = [];
  bool _isCityOverlayVisible = false;

  // Debounce timer for API calls
  Timer? _debounceTimer;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  // List of major cities for autocomplete
  final List<String> _cities = [
    'Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Chennai', 'Kolkata', 'Pune',
    'Ahmedabad', 'Jaipur', 'Surat',
    'Lucknow', 'Kanpur', 'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam',
    'Pimpri-Chinchwad', 'Patna', 'Vadodara',
    'Ghaziabad', 'Ludhiana', 'Agra', 'Nashik', 'Faridabad', 'Meerut', 'Rajkot',
    'Kalyan-Dombivali', 'Vasai-Virar', 'Varanasi',
    'Srinagar', 'Aurangabad', 'Dhanbad', 'Amritsar', 'Allahabad', 'Ranchi',
    'Howrah', 'Coimbatore', 'Jabalpur', 'Gwalior',
    'Vijayawada', 'Jodhpur', 'Madurai', 'Raipur', 'Kota', 'Guwahati',
    'Chandigarh', 'Solapur', 'Hubli-Dharwad', 'Bareilly',
    'Moradabad', 'Mysore', 'Gurgaon', 'Aligarh', 'Jalandhar', 'Tiruchirappalli',
    'Bhubaneswar', 'Salem', 'Warangal', 'Guntur',
    'Bhiwandi', 'Saharanpur', 'Gorakhpur', 'Bikaner', 'Amravati', 'Noida',
    'Jamshedpur', 'Bhilai', 'Cuttack', 'Firozabad',
    'Kochi', 'Nellore', 'Bhavnagar', 'Dehradun', 'Durgapur', 'Asansol',
    'Rourkela', 'Nanded', 'Kolhapur', 'Ajmer',
    'Akola', 'Gulbarga', 'Jamnagar', 'Udaipur', 'Maheshtala', 'Tiruppur',
    'Karnal', 'Bathinda', 'Ujjain', 'Sangli',
    'Bhiwani', 'Cuddalore', 'Vellore', 'Deoghar', 'Kakinada', 'Dewas',
    'Murwara', 'Ganganagar', 'Tirupati', 'Rohtak',
    'Korba', 'Bhilwara', 'Berhampur', 'Muzaffarnagar', 'Ahmednagar', 'Mathura',
    'Kollam', 'Avadi', 'Kadapa', 'Anantapur',
    'Tirunelveli', 'Bharatpur', 'Panipat', 'Ulhasnagar', 'Parbhani', 'Malegaon',
    'Ozhukarai', 'Bihar Sharif', 'Panchkula', 'Burhanpur',
    'Kharagpur', 'Dindigul', 'Gandhinagar', 'Hospet', 'Nangloi Jat', 'Malda',
    'Ongole', 'Deogarh', 'Chapra', 'Haldia',
    'Khandwa', 'Nandyal', 'Morena', 'Amroha', 'Anand', 'Bhind',
    'Bhalswa Jahangir Pur', 'Madhyamgram', 'Bhiwandi', 'Berhampore',
    'Ambala', 'Fatehpur', 'Rae Bareli', 'Khora', 'Rewa', 'Puducherry',
    'Gangtok', 'Kohima', 'Itanagar', 'Shillong',
    'Aizawl', 'Imphal', 'Agartala', 'Kavaratti', 'Panaji', 'Daman', 'Diu',
    'Silvassa',
    'Chandigarh',
    'New Delhi',
    'Hisar, Haryana',
    'Rohtak, Haryana',
    'Panipat, Haryana',
    'Karnal, Haryana',
    'Yamunanagar, Haryana',
    'Sonipat, Haryana',
    'Gurgaon, Haryana',
    'Faridabad, Haryana',
    // International cities
    'New York', 'London', 'Tokyo', 'Paris', 'Sydney', 'Toronto', 'Berlin',
    'Rome', 'Madrid', 'Amsterdam',
    'Vienna', 'Zurich', 'Stockholm', 'Oslo', 'Copenhagen', 'Helsinki', 'Dublin',
    'Brussels', 'Warsaw', 'Prague',
    'Budapest', 'Bucharest', 'Sofia', 'Belgrade', 'Zagreb', 'Ljubljana',
    'Bratislava', 'Vilnius', 'Riga', 'Tallinn',
    'Reykjavik', 'Luxembourg', 'Valletta', 'Nicosia', 'Athens', 'Lisbon',
    'Porto', 'Barcelona', 'Valencia', 'Seville',
    'Milan', 'Florence', 'Venice', 'Naples', 'Turin', 'Genoa', 'Bologna',
    'Palermo', 'Catania', 'Bari',
    'Frankfurt', 'Munich', 'Hamburg', 'Cologne', 'Stuttgart', 'Düsseldorf',
    'Dortmund', 'Essen', 'Leipzig', 'Dresden',
    'Manchester', 'Birmingham', 'Leeds', 'Liverpool', 'Sheffield', 'Glasgow',
    'Edinburgh', 'Bristol', 'Cardiff', 'Belfast',
    'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia',
    'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin',
    'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte', 'San Francisco',
    'Indianapolis', 'Seattle', 'Denver', 'Washington', 'Boston',
    'El Paso', 'Nashville', 'Detroit', 'Oklahoma City', 'Portland', 'Las Vegas',
    'Memphis', 'Louisville', 'Baltimore', 'Milwaukee',
    'Albuquerque', 'Tucson', 'Fresno', 'Sacramento', 'Mesa', 'Kansas City',
    'Atlanta', 'Long Beach', 'Colorado Springs', 'Raleigh',
    'Miami', 'Virginia Beach', 'Omaha', 'Oakland', 'Minneapolis', 'Tulsa',
    'Arlington', 'Tampa', 'New Orleans', 'Wichita',
    'Cleveland', 'Bakersfield', 'Aurora', 'Anaheim', 'Honolulu', 'Santa Ana',
    'Corpus Christi', 'Riverside', 'Lexington', 'Stockton',
    'Henderson', 'Saint Paul', 'St. Louis', 'Cincinnati', 'Pittsburgh',
    'Greensboro', 'Anchorage', 'Plano', 'Orlando', 'Irvine',
    'Newark', 'Durham', 'Chula Vista', 'Toledo', 'Fort Wayne', 'St. Petersburg',
    'Laredo', 'Jersey City', 'Chandler', 'Madison',
    'Lubbock', 'Scottsdale', 'Reno', 'Buffalo', 'Gilbert', 'Glendale',
    'North Las Vegas', 'Winston-Salem', 'Chesapeake', 'Norfolk',
    'Fremont', 'Garland', 'Irving', 'Hialeah', 'Richmond', 'Boise', 'Spokane',
    'Baton Rouge', 'Tacoma', 'San Bernardino',
    'Grand Rapids', 'Huntsville', 'Salt Lake City', 'Frisco', 'Cary', 'Yonkers',
    'Amarillo', 'Glendale', 'McKinney', 'Montgomery',
    'Augusta', 'Columbus', 'Aurora', 'Amarillo', 'Oxnard', 'Fontana',
    'Moreno Valley', 'Huntington Beach', 'Yonkers', 'Montgomery',
    'Amarillo', 'Glendale', 'McKinney', 'Montgomery', 'Augusta', 'Columbus',
    'Aurora', 'Amarillo', 'Oxnard', 'Fontana',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _scrollController.dispose();
    _nameFocusNode.dispose();
    _genderFocusNode.dispose();
    _dateFocusNode.dispose();
    _cityFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    // Dismiss keyboard and remove focus before showing date picker
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate:
          DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate:
          DateTime.now().subtract(const Duration(days: 3650)), // 10 years ago
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });

      // Scroll to make the city field visible after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent * 0.6,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city =
            place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
        setState(() {
          _cityController.text = city;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detected: $city'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _showGenderPicker() {
    // Dismiss keyboard and remove focus from name field before showing picker
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _genderOptions.map((gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                  });
                  Navigator.of(context).pop();

                  // Scroll to make the date field visible after a short delay
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent * 0.4,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your date of birth'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your city'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _saveProfile() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Save profile data to backend/database
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // TODO: Navigate to main app
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //         builder: (context) => MainApp(),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
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
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside input fields
                  FocusScope.of(context).unfocus();
                  // Close city overlay if open
                  if (_isCityFieldFocused) {
                    _closeCityOverlay();
                  }
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24.0),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Complete Your Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Profile Picture Section
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _showImagePickerDialog,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: _profileImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          _profileImage!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _showImagePickerDialog,
                              child: const Text(
                                'Add Profile Picture',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name Input
                      _buildInputField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 24),

                      // Gender Selection
                      _buildSelectionField(
                        label: 'Gender',
                        value: _selectedGender,
                        onTap: _showGenderPicker,
                        icon: Icons.person_outline,
                        focusNode: _genderFocusNode,
                      ),

                      const SizedBox(height: 24),

                      // Date of Birth
                      _buildSelectionField(
                        label: 'Date of Birth',
                        value: _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : null,
                        onTap: _selectDate,
                        icon: Icons.calendar_today,
                        focusNode: _dateFocusNode,
                      ),

                      const SizedBox(height: 24),

                      // City Input with Location Button
                      Row(
                        children: [
                          Expanded(
                            child: _buildCityInputField(),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            margin: const EdgeInsets.only(top: 32),
                            child: IconButton(
                              onPressed: _isLoadingLocation
                                  ? null
                                  : _getCurrentLocation,
                              icon: _isLoadingLocation
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Save Profile',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // City overlay that slides from top
          if (_isCityOverlayVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 61, 21, 156),
                      Color.fromARGB(255, 131, 81, 217),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header with close button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _closeCityOverlay,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Select Your City',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // City input field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _cityController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            onChanged: (value) {
                              _filterCities(value);
                            },
                            onTap: () {
                              // Ensure keyboard opens
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search for your city...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // City suggestions list
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _filteredCities.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No cities found',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: _filteredCities.length,
                                  itemBuilder: (context, index) {
                                    final city = _filteredCities[index];
                                    return ListTile(
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                      title: Text(
                                        city,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      onTap: () {
                                        _cityController.text = city;
                                        _closeCityOverlay();
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: controller == _nameController ? _nameFocusNode : null,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              // Dismiss keyboard after entering name
              FocusScope.of(context).unfocus();
            },
            onTap: () {
              // Scroll to make the field visible when tapped
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent * 0.3,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.grey,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'City',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _openCityOverlay();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _cityController.text.isEmpty
                          ? 'Enter your city'
                          : _cityController.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: _cityController.text.isEmpty
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionField({
    required String label,
    required String? value,
    required VoidCallback onTap,
    required IconData icon,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          focusNode: focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.tab) {
              // Handle Tab key - move to next field
              if (label == 'Gender') {
                // Don't focus date field since it's not a text input
                // Just scroll to make it visible
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent * 0.4,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else if (label == 'Date of Birth') {
                // Don't focus city field automatically
                // Just scroll to make it visible
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent * 0.6,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value ?? 'Select $label',
                      style: TextStyle(
                        fontSize: 16,
                        color: value != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to open city overlay
  void _openCityOverlay() {
    setState(() {
      _isCityOverlayVisible = true;
      _isCityFieldFocused = true;
    });
    _filterCities(_cityController
        .text); // This is now async but we don't need to await it
  }

  // Method to filter cities based on user input - Static list first, then Google Places API
  Future<void> _filterCities(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredCities = [];
      });
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Debounce the API call
    _debounceTimer = Timer(PlacesConfig.DEBOUNCE_DELAY, () async {
      // First, search in static list
      final staticResults = _cities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .take(PlacesConfig.MAX_RESULTS)
          .toList();

      // If we found results in static list, use them
      if (staticResults.isNotEmpty) {
        setState(() {
          _filteredCities = staticResults;
        });
        return;
      }

      // If no results in static list, try Google Places API
      try {
        final response = await http.get(
          Uri.parse(
              '${PlacesConfig.PLACES_API_BASE_URL}${PlacesConfig.AUTOCOMPLETE_ENDPOINT}?'
              'input=${Uri.encodeComponent(query)}&types=${PlacesConfig.TYPES}&key=${PlacesConfig.GOOGLE_PLACES_API_KEY}'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final predictions = data['predictions'] as List?;

          if (predictions != null && predictions.isNotEmpty) {
            setState(() {
              _filteredCities = predictions
                  .map((pred) => pred['description'] as String)
                  .take(PlacesConfig.MAX_RESULTS)
                  .toList();
            });
          } else {
            // No results found anywhere
            setState(() {
              _filteredCities = [];
            });
          }
        } else {
          // API failed, no results
          setState(() {
            _filteredCities = [];
          });
        }
      } catch (e) {
        // API error, no results
        setState(() {
          _filteredCities = [];
        });
      }
    });
  }

  // Method to close city overlay and dismiss keyboard
  void _closeCityOverlay() {
    setState(() {
      _isCityOverlayVisible = false;
      _isCityFieldFocused = false;
      _filteredCities.clear();
    });
    FocusScope.of(context).unfocus();
  }

  // Method to get city suggestions based on user input (kept for compatibility)
  Iterable<String> _getCitySuggestions(String query) {
    if (query.isEmpty) {
      return const Iterable<String>.empty();
    }

    return _cities.where((city) {
      return city.toLowerCase().contains(query.toLowerCase());
    }).take(8); // Limit to 8 suggestions to reduce height
  }
}
