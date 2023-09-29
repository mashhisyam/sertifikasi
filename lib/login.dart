import 'package:flutter/material.dart';
import 'database.dart';
import 'beranda.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi DatabaseHelper
    DatabaseHelper.instance;
  }

  String _loginMessage = '';

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await DatabaseHelper.instance.getUser(username, password);

    if (user != null) {
      // Login berhasil, arahkan ke halaman BerandaPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BerandaPage()),
      );
    } else {
      setState(() {
        _loginMessage = 'Login gagal. Cek kembali username dan password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Logo Aplikasi
            Image.asset(
              'assets/logo.png', 
              width: 120.0,
            ),
            SizedBox(height: 12.0),

            // Nama Aplikasi
            Text(
              'Cashbook', 
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.0),

            // Form Login
            Text(
              _loginMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
