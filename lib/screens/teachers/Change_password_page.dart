import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isCurrentVisible = false;
  bool isNewVisible = false;
  bool isConfirmVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Current Password',
                      controller: currentPasswordController,
                      isVisible: isCurrentVisible,
                      onToggleVisibility: () =>
                          setState(() => isCurrentVisible = !isCurrentVisible),
                      autofillHint: AutofillHints.password,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'New Password',
                      controller: newPasswordController,
                      isVisible: isNewVisible,
                      onToggleVisibility: () =>
                          setState(() => isNewVisible = !isNewVisible),
                      autofillHint: AutofillHints.newPassword,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      isVisible: isConfirmVisible,
                      onToggleVisibility: () =>
                          setState(() => isConfirmVisible = !isConfirmVisible),
                      autofillHint: AutofillHints.newPassword,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  _showConfirmationDialog(context);
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Update Password',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? autofillHint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(color: Colors.black),
            autofillHints: autofillHint != null ? [autofillHint] : null,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: onToggleVisibility,
              ),
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty)
                return 'Please enter ${_getFieldName(label)}';

              if (controller == newPasswordController && trimmed.length < 8) {
                return 'New password must be at least 8 characters long';
              }

              if (controller == newPasswordController &&
                  trimmed == currentPasswordController.text.trim()) {
                return 'New password must be different from current password';
              }

              if (controller == confirmPasswordController &&
                  trimmed != newPasswordController.text.trim()) {
                return 'Passwords do not match';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  String _getFieldName(String label) {
    switch (label) {
      case 'Current Password':
        return 'your current password';
      case 'New Password':
        return 'a new password';
      case 'Confirm Password':
        return 'the confirmation password';
      default:
        return label.toLowerCase();
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to update your password?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changePassword();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

      // TODO: Replace this with your actual backend API integration:
      // Example:
      // await ApiService.changePassword(
      //   currentPasswordController.text.trim(),
      //   newPasswordController.text.trim(),
      // );

      // If success:
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );

        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Optional: navigate back after short delay
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      // If error:
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to change password. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
