import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDetailsScreen extends StatelessWidget {
  final String? profileImageUrl;

  const PersonalDetailsScreen({Key? key, this.profileImageUrl}) : super(key: key);

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = baseSize;
    if (screenWidth < 320) {
      size = baseSize * 0.85;
    } else if (screenWidth < 375) {
      size = baseSize * 0.9;
    } else if (screenWidth > 600) {
      size = baseSize * 1.1;
    }
    return size.clamp(12, 32); // Clamp to reasonable min/max font size
  }

  Widget _buildSectionTitle(BuildContext context,
      {Widget? leadingWidget, String? emoji, String? title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (leadingWidget != null)
            leadingWidget
          else if (emoji != null)
            Text(
              emoji,
              style: TextStyle(fontSize: _getResponsiveFontSize(context, 16)),
            ),
          if ((leadingWidget != null || emoji != null)) const SizedBox(width: 8),
          if (title != null)
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: _getResponsiveFontSize(context, 16),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.lightBlue.shade200
                      : Colors.blue.shade700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SelectableText.rich(
        TextSpan(
          style: GoogleFonts.poppins(
            fontSize: _getResponsiveFontSize(context, 15),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
        showCursor: true,
        cursorColor: Colors.blue.shade700,
        // Allow soft wrapping for long text
        maxLines: null,
        toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String emoji, String titleText,
      List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, emoji: emoji, title: titleText),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCardWithProfileImage(
      BuildContext context, String titleText, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            leadingWidget: Semantics(
              label: 'Profile Image',
              child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? NetworkImage(profileImageUrl!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
            ),
            title: titleText,
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStyledDivider(BuildContext context) {
    return Divider(
      height: 30,
      thickness: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]
          : Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.06;
    // Clamp padding between 16 and 40
    final double clampedPadding = horizontalPadding.clamp(16.0, 40.0);

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? Colors.black : const Color(0xFFF2F5F8),
      appBar: AppBar(
        title: Text(
          'Personal Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: _getResponsiveFontSize(context, 18),
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: clampedPadding, vertical: 24),
          children: [
            _buildCardWithProfileImage(context, 'Personal Information', [
              _buildField(context, 'Full Name', 'Johnathan Alexander Doe'),
              _buildField(context, 'Gender', 'Male'),
              _buildField(context, 'Date of Birth', '01 January 1980'),
              _buildField(context, 'Nationality', 'American'),
            ]),
            _buildStyledDivider(context),
            _buildCard(context, '📞', 'Contact Information', [
              _buildField(context, 'Phone Number', '+1 123 456 7890'),
              _buildField(context, 'Email Address',
                  'johnathan.doe.superlongemail@exampledomain.com'),
              _buildField(context, 'Emergency Contact', '+1 987 654 3210'),
            ]),
            _buildStyledDivider(context),
            _buildCard(context, '🏠', 'Address', [
              _buildField(context, 'Current Address',
                  '123 Main Street, Springfield, California, USA'),
              _buildField(context, 'Permanent Address',
                  '456 Another Avenue, Capital City, Texas, USA'),
            ]),
            _buildStyledDivider(context),
            _buildCard(context, '🏫', 'Professional Details', [
              _buildField(context, 'Employee ID', 'EMP00123'),
              _buildField(context, 'Department', 'Computer Science and Engineering'),
              _buildField(context, 'Designation', 'Senior Lecturer and Department Head'),
              _buildField(context, 'Joining Date', '15 August 2015'),
              _buildField(context, 'Qualification', 'M.Sc. in Computer Science, Ph.D. in AI'),
              _buildField(context, 'Experience', '10+ years in academia and research'),
            ]),
          ],
        ),
      ),
    );
  }
}
