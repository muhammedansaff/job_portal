import 'package:JOBHUB/Services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Persistent {
  static List<String> jobCategoryList = [
    'hello',
  ];
  static List<String> jobfilterList = [
    'Architecture',
    'Construction',
    'Education',
    'Development',
    'IT',
    'Human Resource',
    'Marketing',
    'Design',
    'Accounting',
    'Painter',
    'Plumber',
    'Driver',
    'Maid',
    'Electrician',
    'Coolie',
    'Cook'
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
