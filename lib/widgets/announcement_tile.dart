import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementTile extends StatelessWidget {
  final String note;
  final Color primaryColor;
  final Color secondaryColor;

  const AnnouncementTile({
    Key? key,
    required this.note,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 20,
          vertical: isSmallScreen ? 10 : 16,
        ),
        child: Row(
          children: [
            Icon(Icons.announcement_rounded,
                color: primaryColor, size: isSmallScreen ? 18 : 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                note,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 13 : 15,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
