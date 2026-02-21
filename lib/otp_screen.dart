import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

  String message = "";

  final String baseUrl = "http://192.168.0.101:8080/api";

  Future verifyOTP() async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": widget.phone, "otp": otpController.text}),
    );

    final data = jsonDecode(response.body);

    if (!mounted) return;

    setState(() {
      message = data["message"];
    });

    if (data["message"] == "OTP verified") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(phone: widget.phone)),
        (route) => false,
      );
    }

    if (data["success"] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Successful")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("OTP sent to ${widget.phone}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: verifyOTP, child: Text("Verify OTP")),
            SizedBox(height: 20),
            Text(message, style: TextStyle(fontSize: 18, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
