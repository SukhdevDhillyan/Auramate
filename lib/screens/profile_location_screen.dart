import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../services/profile_manager.dart';
import '../config/places_config.dart';
import 'profile_picture_screen.dart';

class ProfileLocationScreen extends StatefulWidget {
  final String? detectedCity;
  final double? latitude;
  final double? longitude;

  const ProfileLocationScreen({
    super.key,
    this.detectedCity,
    this.latitude,
    this.longitude,
  });

  @override
  State<ProfileLocationScreen> createState() => _ProfileLocationScreenState();
}

class _ProfileLocationScreenState extends State<ProfileLocationScreen> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();

  bool _isLoadingLocation = false;
  bool _isLoading = false;
  bool _isCityFieldFocused = false;
  List<String> _filteredCities = [];
  bool _isCityOverlayVisible = false;

  // Debounce timer for API calls
  Timer? _debounceTimer;

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
    'Silvassa', 'Chandigarh', 'New Delhi',
    'Hisar, Haryana', 'Rohtak, Haryana', 'Panipat, Haryana', 'Karnal, Haryana',
    'Yamunanagar, Haryana', 'Sonipat, Haryana', 'Gurgaon, Haryana',
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
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final profile = ProfileManager().currentProfile;
    if (profile?.city != null) {
      _cityController.text = profile!.city!;
    } else if (widget.detectedCity != null) {
      _cityController.text = widget.detectedCity!;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cityFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
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

        // Save location data
        ProfileManager().updateLocation(
          city: city,
          latitude: position.latitude,
          longitude: position.longitude,
          locationPermissionGranted: true,
        );

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

  void _openCityOverlay() {
    setState(() {
      _isCityOverlayVisible = true;
      _isCityFieldFocused = true;
    });
    _filterCities(_cityController.text);
  }

  void _closeCityOverlay() {
    setState(() {
      _isCityOverlayVisible = false;
      _isCityFieldFocused = false;
      _filteredCities.clear();
    });
    FocusScope.of(context).unfocus();
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

  bool _validateForm() {
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

  void _saveAndContinue() {
    if (!_validateForm()) return;

    // Save location data
    ProfileManager().updateLocation(
      city: _cityController.text.trim(),
      latitude: widget.latitude,
      longitude: widget.longitude,
      locationPermissionGranted: widget.detectedCity != null,
    );

    // Navigate to profile picture screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfilePictureScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  FocusScope.of(context).unfocus();
                  if (_isCityFieldFocused) {
                    _closeCityOverlay();
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
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
                            'Your Location',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Progress indicator
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 1.0, // 100% complete (5/5 fields)
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Step 4 of 5',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Detected location info (if available)
                      if (widget.detectedCity != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location Detected',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      widget.detectedCity!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

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

                      const SizedBox(height: 40),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveAndContinue,
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
                                  'Continue',
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
}
