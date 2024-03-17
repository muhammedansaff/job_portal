import 'package:flutter/material.dart';

import 'package:JOBHUB/Widgets/rating.dart';
import 'package:JOBHUB/Widgets/complaints.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ApplWidget extends StatefulWidget {
  final String jobTitle;
  final String jobID;
  final String username;
  final String email;
  final String userImage;
  final String userId;
  final double rating;
  final String phone;
  const ApplWidget({
    Key? key,
    required this.rating,
    required this.phone,
    required this.jobTitle,
    required this.email,
    required this.jobID,
    required this.userImage,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  State<ApplWidget> createState() => _ApplWidgetState();
}

class _ApplWidgetState extends State<ApplWidget> {
  void _showCheckerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog(
          userId: widget.userId,
          username: widget.username,
          jobId: widget.jobID,
        );
      },
    );
  }

  void _showcomplaindialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ComplaintDialog(
          jobID: widget.jobID,
          jobTitle: widget.jobTitle,
          userId: widget.userId,
          userImage: widget.userImage,
          username: widget.username,
          email: widget.email,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Colors.black54,
        shadowColor: const Color.fromARGB(25, 216, 230, 110),
        elevation: 15,
        child: ListTile(
            onTap: () {
              _showCheckerDialog(context);
            },
            onLongPress: () {
              _showcomplaindialog(context);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color(0xFFECE5B6),
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.userImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFECE5B6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4), // Decreased vertical space here
                Row(
                  children: List.generate(
                    5,
                    (index) => _buildStar(
                      index,
                      widget.rating.round().toDouble(),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              widget.email,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            trailing: IconButton(
                onPressed: () {
                  var url = 'tel:${widget.phone}';

                  launchUrlString(url);
                },
                icon: const Icon(
                  FontAwesome.phone,
                  color: Colors.white,
                ))),
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
    );
  }
}
