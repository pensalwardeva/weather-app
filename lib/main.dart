import 'package:flutter/material.dart';
import 'package:testweather/Login%20page.dart';
import 'package:testweather/weather%20screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add an image to your login page
              Image.asset(
                'assets/login_image.png', // Replace with the path to your image asset
                height: 150, // Adjust the height as needed
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  pass = value;
                },
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Add your authentication logic here
                  // For example, you can use FirebaseAuth to sign in
                  // For simplicity, let's consider any non-empty email/pass as a successful login
                  if (email.isNotEmpty && pass.isNotEmpty) {
                    // Navigate to WeatherScreen on successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WeatherScreen()),
                    );
                  } else {
                    // Handle login failure (show error message, etc.)
                    print('Login failed. Please enter valid credentials.');
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
