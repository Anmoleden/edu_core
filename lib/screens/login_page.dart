import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'parents/parents_home_page.dart';

import 'teachers/teachers_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _loginError;
  String? _selectedRole;
  String? _roleError;

  final Color _primaryColor = const Color(0xFFFB9951);

  void _handleRoleSelect(String role) {
    setState(() {
      _selectedRole = role;
      _roleError = null;
    });
  }

  /// Mock login function
  Future<Map<String, dynamic>> loginUser(
      String email, String password, String role) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    const parentData = {
      'email': 'parent@example.com',
      'password': 'parent123',
      'role': 'parent',
      'data': {
        'name': 'Parent User',
        'photoUrl': 'https://via.placeholder.com/150',
      },
    };

    const teacherData = {
      'email': 'teacher@example.com',
      'password': 'teacher123',
      'role': 'teacher',
      'data': {
        'name': 'Teacher User',
        'photoUrl': 'https://via.placeholder.com/150',
      },
    };

    if (role == 'parent' &&
        email == parentData['email'] &&
        password == parentData['password']) {
      return parentData;
    } else if (role == 'teacher' &&
        email == teacherData['email'] &&
        password == teacherData['password']) {
      return teacherData;
    } else {
      return {};
    }
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (_selectedRole == null) {
      setState(() => _roleError = 'Please select a role (Parent or Teacher)');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginError = null;
      });

      final result = await loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole!,
      );

      setState(() => _isLoading = false);

      if (result.isNotEmpty) {
        if (result['role'] == _selectedRole) {
          final data = result['data'];

          if (_selectedRole == 'parent') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ParentsHomePage(
                  parentName: data['name'],
                  parentPhotoUrl: data['photoUrl'],
                ),
              ),
            );
          } else if (_selectedRole == 'teacher') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TeachersHomePage(
                  teacherName: data['name'],
                  teacherPhotoUrl: data['photoUrl'],
                ),
              ),
            );
          }
        } else {
          setState(
              () => _loginError = 'Selected role does not match user role');
        }
      } else {
        setState(() => _loginError = 'Invalid email or password');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1588072432836-e10032774350',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/school_logo.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to School Portal',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Role Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRoleButton('parent'),
                          const SizedBox(width: 16),
                          _buildRoleButton('teacher'),
                        ],
                      ),
                      if (_roleError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _roleError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 30),

                      /// Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration(
                          label: 'Email',
                          icon: Icons.email,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration(
                          label: 'Password',
                          icon: Icons.lock,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter password'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      if (_loginError != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _loginError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Widget to Build Role Button
  Widget _buildRoleButton(String role) {
    final isSelected = _selectedRole == role;
    return ElevatedButton(
      onPressed: () => _handleRoleSelect(role),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? _primaryColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(role[0].toUpperCase() + role.substring(1)),
    );
  }

  /// Input Field Decoration
  InputDecoration _inputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: _primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
