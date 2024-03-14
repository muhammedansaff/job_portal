import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('dadlinetime', isGreaterThan: Timestamp.now())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while waiting for data
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var posturl = document['posturl'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      posturl,
                      fit: BoxFit.cover,
                      height: 400, // Set a fixed height for the image
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
