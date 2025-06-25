import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart'; // For Nepali date conversion
import 'school_event_page.dart'; // Event model

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert to NepaliDateTime and format
    final nepaliDate = NepaliDateTime.fromDateTime(event.dateTime);
    final nepaliDateFormatted =
        NepaliDateFormat('MMMM d, y').format(nepaliDate);
    final timeFormatted =
        '${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}';

    final black = Color(0xFF000000);
    final gray = Color(0xFF8E8E93);
    final lightGray = Color(0xFFF2F2F7);
    final white = Colors.white;

    // Get screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth * 0.05; // 5% margin on sides
    final containerPadding =
        screenWidth > 600 ? 32.0 : 20.0; // More padding on wider screens

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: black),
        title: Text(
          'Event Details',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    color: black,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),

                // Category with icon
                Row(
                  children: [
                    Icon(Icons.category, color: gray, size: 22),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        event.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: gray,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Date with icon (UPDATED to fix overflow)
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // align icon with multiline text
                  children: [
                    Icon(Icons.calendar_today_outlined, color: gray, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Date (BS): $nepaliDateFormatted',
                        style: TextStyle(fontSize: 16, color: gray),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Time with icon
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: gray, size: 22),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Time: $timeFormatted',
                        style: TextStyle(fontSize: 16, color: gray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Location with icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, color: gray, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(fontSize: 16, color: gray),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                Divider(color: gray.withOpacity(0.3), thickness: 1),

                SizedBox(height: 24),

                // Description title
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    color: black,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 12),

                // Description content
                Text(
                  'More detailed information about the event can be displayed here. You can add additional details, links, or instructions as needed to make this page more informative and interactive.',
                  style: TextStyle(
                    fontSize: 16,
                    color: gray,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 30),

                // Back button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back to Events'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: black,
                      foregroundColor: white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black54,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
