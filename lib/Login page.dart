import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testweather/weather%20screen.dart';

import 'constants.dart';
import 'custom button.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back when the back arrow is pressed
              Navigator.of(context).pop();
            },
          ),
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.1),
                      Container(
                        height: height * 0.125,
                        width: height * 0.125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.cloud,
                            size: 48,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        Constants.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                  ),
                  height: height * 0.62,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 28),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 25),
                                ),
                                Text(
                                  "Login in with your Credentials",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(
                                    child: Container(
                                      constraints:
                                      const BoxConstraints(maxHeight: 110),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Image.asset(
                                          'assets/images/login.png'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  loginform(),
                                  SizedBox(
                                    height: height * 0.010,
                                  ),
                                  loginButtonAndnewAcc(height * 0.058),
                                ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginform() {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
            // prefixIcon: Icon(Icons.mobile_friendly),
            prefixIcon: Icon(Icons.phone),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Phone Number';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {

              return 'Please enter a valid email address';

              return 'Please enter a valid phone address';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget loginButtonAndnewAcc(double buttonHeight) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to WeatherScreen on successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WeatherScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Custom background color
            minimumSize: const Size(double.infinity, 50), // Increased width
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),

        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            Get.to(const WeatherScreen());
          },
          child: RichText(
            text: TextSpan(
              text: "Don't have an account",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: " Sign up!",
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10), // Add a SizedBox for spacing
        GestureDetector(
          onTap: () {
           // Get.to( ResetPasswordScreen());
          },
          child: Text(
            "Forgot password?",
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}