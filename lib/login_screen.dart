import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  bool loading = false;

  Future<void> sendOtp() async {
    setState(() {
      loading = true;
    });

    var url = Uri.parse("http://192.168.0.101:8080/api/send-otp");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phoneController.text}),
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return; // ✅ FIX BuildContext warning

    var data = jsonDecode(response.body);

    if (data["success"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            phone: phoneController.text, // ✅ PASS PHONE
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WhatsApp OTP Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone number"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : sendOtp,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
