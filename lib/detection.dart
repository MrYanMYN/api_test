import 'package:http/http.dart' as http;

class Detection {
  final double lat;
  final double long;
  final int human;
  final int car;
  final int animal;

  const Detection(
      {required this.lat,
      required this.long,
      required this.human,
      required this.car,
      required this.animal});

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
        lat: json['latlng'][0],
        long: json['latlng'][1],
        human: json['objectDetected']['human'],
        car: json['objectDetected']['car'],
        animal: json['objectDetected']['animal']);
  }
}

Future<String> getDetection() async {
  Uri url = Uri.parse('https://macamv2.azurewebsites.net/getLatestFrames');
  final response = await http.get(url, headers: {"Accept": "application/json"});

  return response.body;
}
