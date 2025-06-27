import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class ClassDetailPage extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassDetailPage({super.key, required this.classData});

  static const Color backgroundColor = Colors.white;
  static final Color primaryTextColor = Colors.black87;
  static final Color secondaryTextColor = Colors.grey;
  static const Color cardBackgroundColor = Colors.white;
  static final Color shadowColor = Colors.black.withOpacity(0.08);

  String formatNepaliDateTime(NepaliDateTime ndt) {
    const nepaliMonths = [
      '',
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];

    final monthName = nepaliMonths[ndt.month];
    final day = ndt.day.toString();
    final year = ndt.year.toString();
    final hour = ndt.hour.toString().padLeft(2, '0');
    final minute = ndt.minute.toString().padLeft(2, '0');

    return "$day $monthName $year, $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScaleFactorOf(context);

    final NepaliDateTime? nepaliStart = classData['nepaliStartTime'];
    final NepaliDateTime? nepaliEnd = classData['nepaliEndTime'];

    final durationString = (nepaliStart != null && nepaliEnd != null)
        ? "${nepaliEnd.toDateTime().difference(nepaliStart.toDateTime()).inMinutes} mins"
        : "Duration not available";

    final timeRange = (nepaliStart != null && nepaliEnd != null)
        ? "${formatNepaliDateTime(nepaliStart)} - ${formatNepaliDateTime(nepaliEnd)}"
        : "Time not available";

    final int present = classData['present'] ?? 0;
    final int total = classData['total'] ?? 0;
    final double attendanceRate = (total == 0) ? 0 : present / total;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Class Details',
          style: GoogleFonts.poppins(
            fontSize: 18 * textScale,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        foregroundColor: primaryTextColor,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            DelayedFadeIn(
              delay: 50,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                child: Center(
                  child: Text(
                    classData['subject'] ?? 'Subject',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20 * textScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DelayedFadeIn(
              delay: 100,
              child: _sectionTitle("Class Overview", textScale),
            ),
            DelayedFadeIn(
              delay: 150,
              child: _buildCard([
                _infoRow(Icons.book_rounded, "Subject", classData['subject'],
                    textScale),
                _infoRow(
                    Icons.access_time_rounded, "Time", timeRange, textScale),
                _infoRow(Icons.location_on_rounded, "Room", classData['room'],
                    textScale),
                _infoRow(Icons.people_alt_rounded, "Class",
                    classData['className'], textScale),
              ]),
            ),
            DelayedFadeIn(
              delay: 250,
              child: _sectionTitle("Additional Information", textScale),
            ),
            DelayedFadeIn(
              delay: 300,
              child: _buildCard([
                _infoRow(Icons.list_alt_rounded, "Syllabus",
                    classData['syllabus'], textScale),
                _infoRow(Icons.sticky_note_2_rounded, "Note", classData['note'],
                    textScale),
                _infoRow(
                    Icons.timer_rounded, "Duration", durationString, textScale),
              ]),
            ),
            DelayedFadeIn(
              delay: 400,
              child: _sectionTitle("Attendance Info", textScale),
            ),
            DelayedFadeIn(
              delay: 450,
              child: _buildCard([
                _infoRow(Icons.check_circle_outline_rounded, "Present",
                    "$present / $total students", textScale),
                const SizedBox(height: 12),
                Text("Class Attendance Rate",
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textScale,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    )),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  tween: Tween(begin: 0.0, end: attendanceRate),
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      color: Colors.black87,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text("${(attendanceRate * 100).toStringAsFixed(1)}%",
                    style: GoogleFonts.poppins(
                      fontSize: 13 * textScale,
                      color: secondaryTextColor,
                    )),
              ]),
            ),
            const SizedBox(height: 24),
            DelayedFadeIn(
              delay: 500,
              child: Center(
                child: Text(
                  "This schedule is view-only and updated by the admin.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12 * textScale,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, double scale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16 * scale,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, dynamic value, double scale) {
    final displayValue = (value == null || value.toString().trim().isEmpty)
        ? "Not available"
        : value.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: primaryTextColor),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
                children: [
                  TextSpan(
                    text: displayValue,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w400,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// DelayedFadeIn stays the same
class DelayedFadeIn extends StatefulWidget {
  final Widget child;
  final int delay;

  const DelayedFadeIn({super.key, required this.child, this.delay = 0});

  @override
  State<DelayedFadeIn> createState() => _DelayedFadeInState();
}

class _DelayedFadeInState extends State<DelayedFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
