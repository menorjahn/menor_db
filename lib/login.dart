import 'dart:convert';
import 'package:flutter_cv/homepage.dart';
import 'signup.dart'; // Import your SignupPage
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// ... (Your existing imports)

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the form

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = false;

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost/jahnelle/login.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['message'] == 'Login successful') {
        // Navigate to the next screen (Firstpage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homepage()),
        );
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect username or password'),
          ),
        );
      }
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 233, 67, 25),
        title: Text(
          'Welcome!',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Wrap the Form widget around your Column

          key: _formKey, // Set the key for the form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('image/haha.png'),
                height: 100,
                width: 100,
              ),
                            TextFormField(
                style: TextStyle(
                  color: const Color.fromARGB(255, 58, 58, 57),
                  fontFamily: 'RobotoMono',
                ),
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 88, 88, 88)),
                  prefixIcon: Icon(
                    Icons.email,
                    color: const Color.fromARGB(255, 75, 74, 74), // Set icon color as per your design
                  ),
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
                obscureText: false, // Set to false to show the entered text
              ),
              TextFormField(
                style: TextStyle(
                  color: const Color.fromARGB(255, 58, 58, 57),
                  fontFamily: 'RobotoMono',
                ),
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 88, 88, 88)),
                  prefixIcon: Icon(
                    Icons.email,
                    color: const Color.fromARGB(255, 75, 74, 74), // Set icon color as per your design
                  ),
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  }, icon: Icon(showPass ? Icons.visibility : Icons.visibility_off))
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: !showPass,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 233, 67, 25)),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Form is valid, perform login
                    _login();
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
              SizedBox(height: 10), // Add some spacing between buttons
              TextButton(
                onPressed: () {
                  // Navigate to the signup page (SignupPage)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 103, 228),
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      SizedBox(width:5), // Adjust the width as needed for the desired space
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 103, 228),
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}