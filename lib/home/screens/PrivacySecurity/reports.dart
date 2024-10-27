import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final subject = Uri.encodeComponent(_subjectController.text);
      final localUser = UserPreferences.getUser();
      final body = Uri.encodeComponent(
        'From: ${localUser.email}\n\nDescription:\n${_descriptionController.text}',
      );

      final mailtoLink = Uri.parse("mailto:support@cepheusx.com?subject=$subject&body=$body");

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
                child: Text('OK', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Issue'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report an Issue or Feedback',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // TextFormField(
              //   controller: _emailController,
              //   decoration: InputDecoration(
              //     labelText: 'Your Email',
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.teal,
              //       )
              //     ),
              //   ),
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your email';
              //     } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              //       return 'Please enter a valid email address';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  floatingLabelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal
                    )
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  labelText: 'Description',
                  floatingLabelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal
                    )
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the issue';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white
                  ),
                  child: Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
