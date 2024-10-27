import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> launchEmail() async {
      final mailtoLink = Uri.parse("mailto:support@cepheusx.com");
      if (await canLaunchUrl(mailtoLink)) {
        await launchUrl(mailtoLink);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Could not launch email app'),
            content: Text('Please try again or use a different email app.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Questions (FAQs)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: 'What is Atrons?',
                answer: 'Atrons is a book reading and publishing platform',
              ),
              _buildFAQItem(
                question: 'Where can I find Atrons',
                answer: 'You can find Atrons on our official website https://cepheusx.com. You will find it on Google Play Store soon.',
              ),
              _buildFAQItem(
                question: 'Where can I find the user guide?',
                answer: 'The user guide can be found in the app settings under Help.',
              ),
              _buildFAQItem(
                question: 'How do I signup to Atrons', 
                answer: "Download Atrons and use your email and password and fill the necessary info to signup"
              ),
              SizedBox(height: 24),
              Text(
                'Contact Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'For further assistance, feel free to reach out via email:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: launchEmail,
                child: Text(
                  'support@cepheusx.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Alternatively, you can visit our help center for more resources.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question),
      iconColor: Colors.teal,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
