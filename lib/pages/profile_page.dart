import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/pages/login_screen.dart';
import 'package:grocery_app/services/auth/auth_services.dart';
import 'package:grocery_app/widgets/profile_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthServices authServices = AuthServices();

  void _logoutUser(BuildContext context) {
    authServices.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  int selectedTile = 0;

  final String userName = 'Bogdan Nikitin';
  final String profileImageUrl =
      'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 200, 223, 234),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(profileImageUrl),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userName,
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProfileTile(
                          text: 'News Feed',
                          icon: Icons.feed,
                          isSelected: selectedTile == 0,
                          onTap: () {
                            setState(() {
                              selectedTile = 0;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ProfileTile(
                          text: 'Message',
                          icon: Icons.email,
                          isSelected: selectedTile == 1,
                          onTap: () {
                            setState(() {
                              selectedTile = 1;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ProfileTile(
                          text: 'Friends',
                          icon: Icons.group,
                          isSelected: selectedTile == 2,
                          onTap: () {
                            setState(() {
                              selectedTile = 2;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ProfileTile(
                          text: 'Settings',
                          icon: Icons.settings,
                          isSelected: selectedTile == 3,
                          onTap: () {
                            setState(() {
                              selectedTile = 3;
                            });
                          },
                        ),
                        ProfileTile(
                          text: 'log Out',
                          icon: Icons.logout,
                          isSelected: selectedTile == 4,
                          onTap: () {
                            setState(() {
                              selectedTile = 4;
                            });
                            _logoutUser(context);
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
