import 'package:JOBHUB/Widgets/rating.dart';
import 'package:flutter/material.dart';

class ApplWidget extends StatefulWidget {
  final String jobTitle;
  final String jobID;
  final String username;
  final String email;
  final String userImage;
  final String userId;
  const ApplWidget(
      {super.key,
      required this.jobTitle,
      required this.email,
      required this.jobID,
      required this.userImage,
      required this.username,
      required this.userId});

  @override
  State<ApplWidget> createState() => _ApplWidgetState();
}

class _ApplWidgetState extends State<ApplWidget> {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RatingDialog(
                        userId: widget.userId,
                        username: widget.username,
                      )),
            );
          },
          onLongPress: () {},
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
              Text(widget.userId)
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
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
