import 'package:flutter/material.dart';
import 'database.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Kata Sandi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Kata Sandi Lama'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Kata Sandi Baru'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final oldPassword = _oldPasswordController.text;
                final newPassword = _newPasswordController.text;

                final user =
                    await DatabaseHelper.instance.getUser('user', oldPassword);

                if (user != null) {
                  // Kata sandi lama benar
                  final rowsAffected = await DatabaseHelper.instance
                      .updateUser('user', newPassword);

                  if (rowsAffected > 0) {
                    // Kata sandi berhasil diperbarui
                    setState(() {
                      _message = 'Kata Sandi Berhasil Diperbarui';
                    });
                  } else {
                    // Terjadi kesalahan
                    setState(() {
                      _message = 'Terjadi Kesalahan. Silakan Coba Lagi.';
                    });
                  }
                } else {
                  // Kata sandi lama salah
                  setState(() {
                    _message = 'Maaf, Kata Sandi Lama Anda Salah.';
                  });
                }
              },
              child: Text('Simpan'),
            ),
            SizedBox(height: 16.0),
            Text(
              _message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),

            // Informasi Pembuat Aplikasi
            Row(
              children: <Widget>[
                // Foto Pembuat Aplikasi
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(
                      'assets/1941720186.jpg'),
                       // Ganti dengan path foto Anda
                ),
                SizedBox(width: 20.0),
              

                // Nama Pembuat Aplikasi dan Nomor Handphone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'About This App', // Ganti dengan nama Anda
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      'Nama: Hisyam Haryo Mahdyan', // Ganti dengan nama Anda
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      'NIM: 1941720186', // Ganti dengan nomor handphone Anda
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      'Tanggal: 28 September 2023', // Ganti dengan nomor handphone Anda
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
