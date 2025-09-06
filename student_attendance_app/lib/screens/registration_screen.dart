import 'package:flutter/material.dart';
import 'package:student_attendance_app/services/auth_service.dart';
import 'package:student_attendance_app/screens/student_dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Create controllers for the email and password text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create an instance of the AuthService to handle authentication.
  final AuthService _authService = AuthService();

  // A boolean to track the loading state.
  bool _isLoading = false;

  // A string to hold any error messages.
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email text field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              // Password text field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Show a loading indicator if the app is currently registering.
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
              // Show an error message if there is one.
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // A method to handle the registration process.
  void _register() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // Create a new user with email and password using the AuthService.
        final user = await _authService.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        // If the registration is successful, navigate to the StudentDashboardScreen.
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const StudentDashboardScreen(),
            ),
          );
        }
      } catch (e) {
        // If there is an error, show an error message.
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        // Set the loading state to false.
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
