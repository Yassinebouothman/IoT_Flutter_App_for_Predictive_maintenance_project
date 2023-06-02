import 'dart:convert';
import 'package:http/http.dart' as http;

class MyUtils {
  static final MyUtils _instance = MyUtils._internal();

  factory MyUtils() => _instance;

  MyUtils._internal();

  final String apiURL =
      'http://demo.thingsboard.io/api/plugins/telemetry/DEVICE/850495d0-f891-11ed-b801-c5ecb7388b5e/values/timeseries?keys=Temperature,Current,Vibration,Time to failure,Anomaly';
  String? _accessToken;
  DateTime? _tokenExpirationTime;

  Future<String> _getNewToken() async {
    // Make a POST request to authenticate and obtain a new JWT token
    String authURL = 'http://demo.thingsboard.io/api/auth/login';
    var response = await http.post(Uri.parse(authURL),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": "bouyassine48@gmail.com",
          "password": "pfa@123456789"
        }));
    print(response.statusCode);
    var data = json.decode(response.body);
    return data['token'];
  }

  // underscore "_" at the start of function name means the function is private
  Future<String> getAccessToken() async {
    // Check if the cached token has expired
    if (_accessToken != null &&
        _tokenExpirationTime != null &&
        _tokenExpirationTime!.isAfter(DateTime.now())) {
      return _accessToken!;
    }
    // Request a new token if the cached token has expired or doesn't exist
    _accessToken = await _getNewToken();
    _tokenExpirationTime = DateTime.now().add(Duration(minutes: 30));
    return _accessToken!;
  }
}
