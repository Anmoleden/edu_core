import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:edu_core/widgets/todays_schedule_card.dart';
import 'package:edu_core/widgets/announcement_tile.dart';
import 'package:edu_core/widgets/action_button.dart';
import 'package:edu_core/widgets/stat_card.dart';
import 'package:edu_core/widgets/chip_link.dart';

import 'messages_tab.dart';
import 'personal_details_screen.dart';
import 'teacher_payment_notice_page.dart';
import 'teacher_feedback_page.dart';
import 'apply_leave_page.dart';
import 'Change_password_page.dart';
import 'package:edu_core/widgets/logout_list_tile.dart';
import 'school_event_page.dart';
import 'resources_page.dart';
import 'faqs_page.dart';
import 'class_detail_page.dart';

class TeachersHomePage extends StatefulWidget {
  final String teacherName;
  final String? teacherPhotoUrl;

  const TeachersHomePage({
    Key? key,
    required this.teacherName,
    required this.teacherPhotoUrl,
  }) : super(key: key);

  @override
  State<TeachersHomePage> createState() => _TeachersHomePageState();
}

class _TeachersHomePageState extends State<TeachersHomePage> {
  final Color primaryColor = const Color(0xFFE65100);
  final Color secondaryColor = const Color(0xFFFF9800);
  final Color surfaceColor = const Color(0xFFFFEFC7);

  int _currentIndex = 0;

  // Simulate fetching today's schedule dynamically
  Future<List<Map<String, dynamic>>> fetchTodaysSchedule() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'subject': 'Mathematics',
        'time': '9:00 AM - 10:00 AM',
        'room': 'Room 12',
        'className': 'Class 5A',
        'nepaliStartTime': null,
        'nepaliEndTime': null,
        'present': 20,
        'total': 25,
        'syllabus': 'Algebra basics',
        'note': 'Bring calculators',
      },
      {
        'subject': 'Science',
        'time': '10:15 AM - 11:15 AM',
        'room': 'Room 15',
        'className': 'Class 6B',
        'nepaliStartTime': null,
        'nepaliEndTime': null,
        'present': 22,
        'total': 24,
        'syllabus': 'Introduction to plants',
        'note': '',
      },
      {
        'subject': 'History',
        'time': '11:30 AM - 12:15 PM',
        'room': 'Room 9',
        'className': 'Class 7C',
        'nepaliStartTime': null,
        'nepaliEndTime': null,
        'present': 18,
        'total': 20,
        'syllabus': 'Medieval period',
        'note': 'Focus on dates',
      },
    ];
  }

  // Simulate fetching announcements dynamically
  Future<List<String>> fetchAnnouncements() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      'School closed next Friday.',
      'Parent-teacher meeting on Monday.',
      'New library books available from Tuesday.',
    ];
  }

  // Simulate fetching quick stats dynamically
  Future<Map<String, String>> fetchQuickStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'Grades Overview': '75%',
      'Behavior Reports': '3 incidents',
      'Progress Tracking': 'On Track',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _currentIndex == 0
              ? 'Welcome, ${widget.teacherName}'
              : _currentIndex == 1
                  ? 'Messages'
                  : _currentIndex == 2
                      ? 'Calendar'
                      : 'Profile & Settings',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          if (_currentIndex == 0 || _currentIndex == 3)
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                widget.teacherPhotoUrl ??
                    'https://images.unsplash.com/photo-1588072432836-e10032774350',
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: _buildTabContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildMessagesTab();
      case 2:
        return _buildCalendarTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    String formattedDate =
        DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey[700])),
              Image.asset('assets/images/school_logo.png',
                  height: 40, width: 40, fit: BoxFit.contain),
            ],
          ),
          const SizedBox(height: 20),

          // Today's Schedule
          Text("Today's Schedule",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          const SizedBox(height: 12),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchTodaysSchedule(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error loading schedule',
                    style: GoogleFonts.poppins(color: Colors.red));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No schedule available',
                    style: GoogleFonts.poppins(color: Colors.grey));
              } else {
                final schedule = snapshot.data!;
                return Column(
                  children: schedule.map((cls) {
                    return TodaysScheduleCard(
                      subject: cls['subject'] ?? 'Unknown',
                      time: cls['time'] ?? '',
                      room: cls['room'] ?? '',
                      primaryColor: primaryColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClassDetailPage(
                              classData: cls,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // Announcements
          Text('Announcements',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          const SizedBox(height: 12),

          FutureBuilder<List<String>>(
            future: fetchAnnouncements(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error loading announcements',
                    style: GoogleFonts.poppins(color: Colors.red));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No announcements available',
                    style: GoogleFonts.poppins(color: Colors.grey));
              } else {
                final notes = snapshot.data!;
                return Column(
                  children: notes
                      .map((note) => AnnouncementTile(
                            note: note,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                          ))
                      .toList(),
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // Class Management
          Text('Class Management',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              ActionButton(
                  icon: Icons.list_alt,
                  label: 'View Class List',
                  primaryColor: primaryColor,
                  surfaceColor: surfaceColor,
                  onTap: () {}),
              ActionButton(
                  icon: Icons.check_box,
                  label: 'Take Attendance',
                  primaryColor: primaryColor,
                  surfaceColor: surfaceColor,
                  onTap: () {}),
              ActionButton(
                  icon: Icons.assignment,
                  label: 'Assign Homework',
                  primaryColor: primaryColor,
                  surfaceColor: surfaceColor,
                  onTap: () {}),
              ActionButton(
                  icon: Icons.upload_file,
                  label: 'Upload Materials',
                  primaryColor: primaryColor,
                  surfaceColor: surfaceColor,
                  onTap: () {}),
            ],
          ),

          const SizedBox(height: 24),

          // Student Performance
          Text('Student Performance',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          const SizedBox(height: 12),

          FutureBuilder<Map<String, String>>(
            future: fetchQuickStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error loading stats',
                    style: GoogleFonts.poppins(color: Colors.red));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No stats available',
                    style: GoogleFonts.poppins(color: Colors.grey));
              } else {
                final stats = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: stats.entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: StatCard(
                                title: entry.key,
                                value: entry.value,
                                primaryColor: primaryColor,
                                surfaceColor: surfaceColor,
                              ),
                            ))
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return MessagesTab();
  }

  Widget _buildCalendarTab() {
    return Center(
      child: Text('Calendar coming soon...',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        ListTile(
          leading: Icon(Icons.person, color: primaryColor),
          title: Text('Personal Details',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalDetailsScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.payment, color: primaryColor),
          title: Text(
            'Payment Notice',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeacherPaymentNoticePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: primaryColor),
          title: Text(
            'Feedback',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherFeedbackPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.event_note, color: primaryColor),
          title: Text(
            'Apply Leave',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApplyLeavePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.lock, color: primaryColor),
          title: Text('Change Password',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            );
          },
        ),
        LogoutListTile(primaryColor: primaryColor),
        const SizedBox(height: 24),
        Text('Quick Links',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            ChipLink(
              label: 'Events',
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SchoolEventPage()),
                );
              },
            ),
            ChipLink(
              label: 'Resources',
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ResourcesPage()),
                );
              },
            ),
            ChipLink(
              label: 'FAQs',
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FAQsPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
