import 'package:JOBHUB/Services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Persistent {
  static List<String> jobCategoryList = [
    'hello',
  ];
  static List<String> jobfilterList = [
    'Painter',
    'Plumber',
    'Driver',
    'Maid',
    'Electrician',
    'Coolie',
    'Cook',
    'tree climber',
    'sweaper',
    'catering',
    'delivery',
    'interlock worker',
    'carpenter',
    'Architecture',
    'Construction',
    'Education',
    'Development',
    'IT',
    'Human Resource',
    'other',
  ];
  // needed datas

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
    location = userDoc.get('location');
  }
}
