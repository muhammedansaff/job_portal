import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final String userId;
  final String username;
  final String jobId;
  const RatingDialog(
      {super.key,
      required this.userId,
      required this.username,
      required this.jobId});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate The user ${widget.username}'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => _buildStar(index, _rating),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () async {
            DocumentSnapshot ratingSnapshot = await FirebaseFirestore.instance
                .collection('ratings')
                .doc(widget.userId)
                .get();

            double currentRating =
                ratingSnapshot.exists ? ratingSnapshot['rating'] : 0.0;
            int k = ratingSnapshot.exists ? ratingSnapshot['ratedusers'] : 0;

            double newRating = (currentRating * k + _rating) / (k + 1);
            int newRatersCount = k + 1;

// Update rating in Firestore
            await FirebaseFirestore.instance
                .collection('ratings')
                .doc(widget.userId)
                .set({
              'userId': widget.userId,
              'rating': newRating,
              'name': widget.username,
              // Add other relevant data (e.g., timestamp)
              'timestamp': DateTime.now(),
              'ratedusers': newRatersCount,
            });
            await FirebaseFirestore.instance
                .collection('acceptedworkers')
                .doc(widget.userId)
                .update({
              'rating': newRating,
            });
            await FirebaseFirestore.instance
                .collection('jobs')
                .doc(widget.jobId)
                .collection('appliedusers')
                .doc(widget.userId)
                .update({
              'rating': newRating,
            });

            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _buildStar(int index, double rating) {
    IconData iconData = Icons.star_border;
    Color color = Colors.grey;

    if (index < rating) {
      iconData = Icons.star;
      color = Colors.amber;
    }

    return IconButton(
      icon: Icon(iconData, color: color),
      onPressed: () {
        setState(() {
          _rating = index + 1.0;
        });
      },
    );
  }
}
