import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password',
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _passwordError = '';
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasNum = false;
  bool _hasSymbol = false;
  bool _isMinLength = false;
  bool _isValid = true;

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  void _checkPassword(String value) {
    bool hasUpper = value.contains(RegExp(r'[A-Z]'));
    bool hasLower = value.contains(RegExp(r'[a-z]'));
    bool hasNum = value.contains(RegExp(r'\d'));
    bool hasSymbol = value.contains(RegExp(r'[!@#$%^&*(),.?:{}|<>]'));
    bool isMinLength = value.length >= 8;
    bool isValid = !value.contains(RegExp(r'[\s;,\\"]'));

    setState(() {
      _hasUpper = hasUpper;
      _hasLower = hasLower;
      _hasNum = hasNum;
      _hasSymbol = hasSymbol;
      _isMinLength = isMinLength;
      _isValid = isValid;
    });

    if (!hasUpper || !hasLower || !hasNum || !hasSymbol || !isMinLength) {
      _passwordError = 'You must include uppercase, lowercase, numbers, and symbols.';
    } else if (!isValid) {
      _passwordError = 'Password contains an invalid character.';
    } else {
      _passwordError = '';
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Password changed successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmPasswordChange() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordError = 'Passwords do not match.';
      });
    } else if (_hasUpper && _hasLower && _hasNum && _hasSymbol && _isValid) {
      setState(() {
        _passwordError = '';
      });

      _showSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Dummy Old Password field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                onChanged: _checkPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  errorText: _passwordError.isEmpty ? null : _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showNewPassword,
              ),
              SizedBox(height: 20),
              Text('Password must contain:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(_hasLower ? Icons.check_circle : Icons.cancel, color: _hasLower ? Colors.green : Colors.red),
                  SizedBox(width: 10),
                  Text('Lowercase letter')
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(_hasUpper ? Icons.check_circle : Icons.cancel, color: _hasUpper ? Colors.green : Colors.red),
                  SizedBox(width: 10),
                  Text('Uppercase letter')
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(_hasSymbol ? Icons.check_circle : Icons.cancel, color: _hasSymbol ? Colors.green : Colors.red),
                  SizedBox(width: 10),
                  Text('Special character')
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(_hasNum ? Icons.check_circle : Icons.cancel, color: _hasNum ? Colors.green : Colors.red),
                  SizedBox(width: 10),
                  Text('Number')
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(_isMinLength ? Icons.check_circle : Icons.cancel, color: _isMinLength ? Colors.green : Colors.red),
                  SizedBox(width: 10),
                  Text('At least 8 characters')
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmation',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showConfirmPassword,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmPasswordChange,
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
