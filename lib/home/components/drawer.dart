import 'dart:io';

import 'package:atrons_v1/colors.dart';
import 'package:atrons_v1/home/components/logout.dart';
import 'package:atrons_v1/home/screens/Help/help.dart';
// import 'package:atrons_v1/home/screens/History/History.dart';
// import 'package:atrons_v1/home/screens/Help/Help.dart';
// import 'package:atrons_v1/home/screens/History/History.dart';
// import 'package:atrons_v1/home/screens/Notifications/Notifications.dart';
import 'package:atrons_v1/home/screens/Payment/Payment.dart';
import 'package:atrons_v1/home/screens/Profile/edit_profile.dart';
import 'package:atrons_v1/home/screens/Profile/profile.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:atrons_v1/themes.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, this.user});
  final User? user;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final localUser = UserPreferences.getUser();
    bool isDarkMode = localUser.isDarkMode;
    //print(localUser.email);
    Object image;

    if (localUser.imagePath.contains('https://')) {
      image = NetworkImage(localUser.imagePath);
    } else if (localUser.imagePath.contains('assets')) {
      image = AssetImage(localUser.imagePath);
    } else {
      image = FileImage(File(localUser.imagePath));
    }
    // ignore: unused_local_variable
    String uidd = '';
    String uemail = '';
    final userid = FirebaseAuth.instance.currentUser;
    if (userid != null) {
      uidd = userid.uid;
      uemail = userid.email!;
      //print(uemail);
    }

    // Scrollable Drawer
    return Drawer(
      key: drawerKey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: isDarkMode ? const Color(0xFF233040) : Colors.teal,
                      width: double.infinity,
                      height: 190,
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 10,
                        left: 20,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Ink.image(
                                  image: image as ImageProvider,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const EditProfile(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              // user?.displayName ?? 'Default',
                              localUser.name,
                              style: TextStyle(
                                color: MyColors.whiteGreenmod,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              //user?.email ?? 'example@email.com',

                              uemail,
                              style: TextStyle(
                                color: MyColors.whiteGreenmod.withOpacity(0.7),
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    drawerItem(
                      context,
                      Icons.payment_rounded,
                      'Payment',
                      const Payment(),
                    ),
                    drawerItem(
                      context,
                      Icons.person,
                      'Profile',
                      const EditProfile()
                    ),
                    drawerItem(
                      context,
                      Icons.settings,
                      'Settings',
                      const Profile(),
                    ),
                    // drawerItem(
                    //   context,
                    //   Icons.history_edu,
                    //   'History',
                    //   const History(),
                    // ),
                    // drawerItem(
                    //   context,
                    //   Icons.notifications_none,
                    //   'Notifications',
                    //   const Notifications(),
                    // ),
                    drawerItem(
                      context,
                      Icons.help_center_outlined,
                      'Help',
                      const Help(),
                    ),
                    const SizedBox(height: 50),
                    Expanded(child: Container()),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 15, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              Icons.logout,
                              color:
                                  isDarkMode ? Colors.white60 : Colors.black54,
                            ),
                            label: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode
                                    ? Colors.white60
                                    : Colors.black54,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await LogoutDialog.show(
                                context,
                                title: 'Confirm Logout',
                                body: 'Are you sure you want to logout?',
                              );
                            },
                          ),
                          ThemeSwitcher(
                            builder: (context) {
                              return IconButton(
                                icon: isDarkMode
                                    ? const Icon(Icons.sunny)
                                    : const Icon(Icons.dark_mode),
                                color: const Color(0xFF234764),
                                onPressed: () {
                                  final theme = isDarkMode
                                      ? MyThemes.lightTheme
                                      : MyThemes.darkTheme;
                                  final switcher = ThemeSwitcher.of(context);
                                  switcher.changeTheme(theme: theme);

                                  final newUser =
                                      localUser.copy(isDarkMode: !isDarkMode);
                                  UserPreferences.setUser(newUser);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   width: double.infinity,
                    //   child: const Text(
                    //     'Atrons_1.0   @CepheusTech',
                    //     style: TextStyle(fontSize: 11),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Material drawerItem(context, icon, text, goto) {
    final color = UserPreferences.getUser().isDarkMode
        ? Colors.white70
        : Colors.black87.withOpacity(0.7);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => goto,
            ),
          );
        },
        leading: Text(
          String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 26,
            inherit: false,
            color: color,
            fontWeight: FontWeight.w100,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
          ),
        ),
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        minLeadingWidth: 30,
        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      ),
    );
  }
}
