import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodaysScheduleCard extends StatelessWidget {
  final String subject;
  final String time;
  final String room;
  final Color primaryColor;
  final Color surfaceColor;
  final VoidCallback? onTap;

  const TodaysScheduleCard({
    Key? key,
    required this.subject,
    required this.time,
    required this.room,
    required this.primaryColor,
    required this.surfaceColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          subject,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        subtitle: Text(
          '$time | $room',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: primaryColor),
      ),
    );
  }
}
