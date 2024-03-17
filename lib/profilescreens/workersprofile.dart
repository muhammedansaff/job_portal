import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final bool isWorker;

  const ProfileScreen(
      {super.key, required this.userId, required this.isWorker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  String profession = '';
  bool _isloading = true;
  late double _rating = 0;
  bool _isSameUser = false;

  @override
  void initState() {
    super.initState();
    widget.isWorker ? getworkerDataProfile() : getUserDataProfile();
  }

  void getUserDataProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });

        setState(() {
          _isloading = false; // Update loading state after data fetch
        });
      } else {
        // Document doesn't exist
        setState(() {
          _isloading = false;
          print(imageUrl); // Update loading state after data fetch
        });
      }
    } catch (error) {
      // Handle error
      setState(() {
        User? user = auth.currentUser;
        final uid = user!.uid;
        _isloading = false; // Update loading state after error
        print(_isSameUser);
        _isSameUser = uid == widget.userId;
        print(name);
      });
    }
  }

  void getworkerDataProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('acceptedworkers')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('imageUrl');
          profession = userDoc.get('profession');
          _rating = userDoc.get('rating');
        });

        setState(() {
          _isloading = false; // Update loading state after data fetch
        });
      } else {
        // Document doesn't exist
        setState(() {
          _isloading = false; // Update loading state after data fetch
        });
      }
    } catch (error) {
      // Handle error
      setState(() {
        User? user = auth.currentUser;
        final uid = user!.uid;
        _isloading = false; // Update loading state after error

        _isSameUser = uid == widget.userId;
      });
    }
  }

  void openWhatsappChat(String phoneNumber) async {
    var url = 'https://wa.me/+91$phoneNumber';
    await launchUrlString(url);
  }

  emailto(email) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Apllying for please&body=Hello,please attach Resume cv file',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void openPhone(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    await launchUrlString(url);
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          content,
          style: const TextStyle(color: Colors.black),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE2B6),
      appBar: AppBar(
        title: Text(_isSameUser ? 'My Profile' : 'Profile'),
      ),
      body: _isloading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Display progress indicator while loading
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return _buildStar(index, _rating);
                    }),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    name!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 20),
                  const Text(
                    'Account Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  userInfo(icon: FontAwesome.mail, content: email),
                  const SizedBox(height: 10),
                  userInfo(icon: FontAwesome.phone, content: phoneNumber),
                  const SizedBox(height: 10),
                  userInfo(icon: FontAwesome.briefcase, content: profession),
                  const SizedBox(height: 40),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleIconButton(
                        icon: FontAwesome.whatsapp,
                        color: Colors.green,
                        onPressed: () => openWhatsappChat(phoneNumber),
                      ),
                      CircleIconButton(
                        icon: FontAwesome.phone,
                        color: Colors.blue,
                        onPressed: () => openPhone(phoneNumber),
                      ),
                      CircleIconButton(
                        icon: FontAwesome.mail,
                        color: Colors.red,
                        onPressed: () => emailto(email),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildStar(int index, double rating) {
    IconData iconData = Icons.star_border;

    Color color = Colors.grey;

    if (index < rating) {
      iconData = Icons.star;
      color = Colors.amber;
    }

    return Icon(
      iconData,
      color: color,
      size: 20,
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
