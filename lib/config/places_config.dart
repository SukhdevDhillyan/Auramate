class PlacesConfig {
  // Google Places API Key
  // Replace this with your actual Google Places API key
  // You can get one from: https://console.cloud.google.com/
  static const String GOOGLE_PLACES_API_KEY =
      'AIzaSyCfZp7Vq08tW-VpG3Jox82TSVxMk8rLuwU';

  // Google Places API Base URL
  static const String PLACES_API_BASE_URL =
      'https://maps.googleapis.com/maps/api/place';

  // Autocomplete endpoint
  static const String AUTOCOMPLETE_ENDPOINT = '/autocomplete/json';

  // Place Details endpoint (for future use)
  static const String PLACE_DETAILS_ENDPOINT = '/details/json';

  // API Configuration
  static const int MAX_RESULTS = 10;
  static const String TYPES = '(cities)'; // Restrict to cities only

  // Rate limiting (optional)
  static const Duration DEBOUNCE_DELAY = Duration(milliseconds: 300);

  // Error messages
  static const String API_ERROR_MESSAGE =
      'Unable to fetch cities. Please try again.';
  static const String NETWORK_ERROR_MESSAGE =
      'Network error. Please check your connection.';
  static const String NO_RESULTS_MESSAGE =
      'No cities found. Try a different search term.';
}
