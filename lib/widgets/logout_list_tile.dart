import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutListTile extends StatelessWidget {
  final Color primaryColor;
  final Future<void> Function()? onLogout;

  const LogoutListTile({
    Key? key,
    required this.primaryColor,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: primaryColor),
      title: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: () async {
        final bool? confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final double width = MediaQuery.of(context).size.width;
            final double titleFontSize = width * 0.05;
            final double messageFontSize = width * 0.04;

            bool isLoading = false;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  semanticLabel: 'Logout Confirmation',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  title: Text(
                    'Confirm Logout',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: titleFontSize.clamp(16, 22).toDouble(),
                      color: Colors.black87,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you sure you want to log out?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: messageFontSize.clamp(13, 18).toDouble(),
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                    ],
                  ),
                  actionsPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  actions: [
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() => isLoading = true);

                              // Optional small UX delay
                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              // Perform logout if provided
                              if (onLogout != null) {
                                await onLogout!();
                              }

                              // Close dialog after logout completes
                              if (context.mounted) {
                                Navigator.of(context).pop(true);
                              }
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
        );

        // If confirmed, navigate to login screen and clear stack
        if (confirmed == true && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      },
    );
  }
}
