
class ApiConfig {
  static const bool isProduction = false; // Change this to true when backend is deployed

  static String get baseUrl {
    if (isProduction) {
      return 'https://yourdeployedbackend.com/api/v1'; // Replace with your actual deployed backend URL
    } else {
      return 'http://192.168.1.15:3000/api/v1'; // Your local/dev backend URL
    }
  }
}
