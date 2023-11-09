import 'package:atrons_v1/home/screens/Help/Help.dart';
import 'package:atrons_v1/home/screens/History/History.dart';
import 'package:atrons_v1/home/screens/Payment/Payment.dart';
import 'package:atrons_v1/home/screens/PrivacySecurity/change_password.dart';
import 'package:atrons_v1/home/screens/Profile/profile_widget.dart';
// import 'package:atrons_v1/home/screens/appearance.dart';
import 'package:atrons_v1/models/user.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:atrons_v1/home/screens/Profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = UserPreferences.getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushReplacement(
                context,
                PageTransition(
                  child: const EditProfile(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {
              await Navigator.pushReplacement(
                context,
                PageTransition(
                  child: const EditProfile(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                user.email,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          profileItem(context, Icons.payment, 'Payment Account', const Payment()),
          ExpansionTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy & Security'),
            iconColor: user.isDarkMode ? Colors.white : Colors.black,
            textColor: user.isDarkMode ? Colors.white : Colors.black,
            children: [
              profileItem(context, CupertinoIcons.lock_shield_fill,
                  'Change Password', const ChangePassword()),
              profileItem(context, CupertinoIcons.lock_shield_fill,
                  'Privacy Policy', const ChangePassword()),
              profileItem(context, CupertinoIcons.lock_shield_fill,
                  'Terms of Service', const ChangePassword()),
              profileItem(context, CupertinoIcons.lock_shield_fill, 'Report',
                  const ChangePassword()),
            ],
          ),
          profileItem(context, CupertinoIcons.timer, 'History', const History()),
          // profileItem(context, Icons.color_lens, 'Appearance', const Appearance()),
          // ListTile(
          //   leading: const Icon(Icons.notifications_active),
          //   title: const Text('Notifications'),
          //   trailing: Switch(
          //     value: user.notifications,
          //     onChanged: (value) {
          //       user = user.copy(notifications: !user.notifications);
          //       UserPreferences.setUser(user);
          //       setState(() {});
          //     },
          //   ),
          // ),
          ExpansionTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            iconColor: user.isDarkMode ? Colors.white : Colors.black,
            textColor: user.isDarkMode ? Colors.white : Colors.black,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('English'),
                  Radio(
                    value: 'English',
                    groupValue: user.language,
                    onChanged: (String? value) {
                      user = user.copy(language: value);
                      UserPreferences.setUser(user);
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('አማርኛ'),
                  Radio(
                    value: 'Amharic',
                    groupValue: user.language,
                    onChanged: (value) {
                      user = user.copy(language: value.toString());
                      UserPreferences.setUser(user);
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('ትግርኛ'),
                  Radio(
                    value: 'Tigrinya',
                    groupValue: user.language,
                    onChanged: (value) async {
                      user = user.copy(language: value.toString());
                      await UserPreferences.setUser(user);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
          profileItem(context, Icons.help, 'Help & Support', const Help()),
        ],
      ),
    );
  }

  Widget profileItem(
      BuildContext context, IconData icon, String name, Widget goto) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: goto,
            type: PageTransitionType.rightToLeft,
          ),
        );
      },
    );
  }
}
