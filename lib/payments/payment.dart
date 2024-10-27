import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyPayment {
  static Future<void> initializePayment({
    required String amount,
    required String currency,
    required String email,
    required String firstName,
    required String lastName,
    required String txRef,
    required String callbackUrl,
  }) async {
    final url = Uri.parse("https://api.chapa.co/v1/transaction/initialize");
    String chapaSecretKey = dotenv.env['CHAPA_SECRET_KEY'] ?? '';

    final headers = {
      'Authorization': 'Bearer $chapaSecretKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'amount': amount,
      'currency': currency,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'tx_ref': txRef,
      'callback_url': callbackUrl,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final checkoutUrl = responseData['data']['checkout_url'];
        print("Redirecting to payment: $checkoutUrl");

        // Redirect to payment page
        if (await canLaunchUrl(checkoutUrl)) {
          await launchUrl(checkoutUrl);
        } else {
          throw 'Could not launch $checkoutUrl';
        }
      } else {
        print("Failed to initialize payment. Error: ${response.body}");
      }
    } catch (e) {
      print("Error initializing payment: $e");
    }
  }

  static Future<void> verifyPayment(String txRef) async {
    String chapaSecretKey = "YOUR_SECRET_KEY";
    final response = await http.get(
      Uri.parse('https://api.chapa.co/v1/transaction/verify/$txRef'),
      headers: {
        "Authorization": "Bearer $chapaSecretKey",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        print('Payment verified successfully');
      } else {
        print('Payment verification failed');
      }
    } else {
      print('Failed to verify payment: ${response.body}');
    }
  }


}
