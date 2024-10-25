import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;
  late TextEditingController currentPassword;

  @override
  void initState() {
    super.initState();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();
    currentPassword = TextEditingController();
  }

  @override
  void dispose() {
    newPassword.dispose();
    confirmPassword.dispose();
    currentPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FCFB),
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(CupertinoIcons.lock_shield_fill),
            SizedBox(width: 6),
            Text('Change Password'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark_circled),
            color: Colors.black,
            iconSize: 32,
            onPressed: () {
              // change user password
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          children: [
            PasswordField(
              label: 'Current Password',
              controller: currentPassword,
              onChanged: (value) {},
            ),
            PasswordField(
              label: 'New Password',
              controller: newPassword,
              onChanged: (value) {},
            ),
            PasswordField(
              label: 'Confirm Password',
              controller: confirmPassword,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.controller,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: Color(0x00e7f8f6),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
