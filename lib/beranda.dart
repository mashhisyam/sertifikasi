import 'package:flutter/material.dart';
import 'pemasukan.dart';
import 'pengeluaran.dart';
import 'flow.dart';
import 'database.dart';
import 'setting.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  num totalPengeluaran = 0;
  num totalPemasukan = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalPengeluaran();
    _fetchTotalPemasukan();
  }

  Future<void> _fetchTotalPengeluaran() async {
    final pengeluaranData = await DatabaseHelper.instance.getPengeluaran();
    num total = 0;
    for (var data in pengeluaranData) {
      total += data['nominal'];
    }
    setState(() {
      totalPengeluaran = total;
    });
  }

  Future<void> _fetchTotalPemasukan() async {
    final pemasukanData = await DatabaseHelper.instance.getPemasukan();
    num total = 0;
    for (var data in pemasukanData) {
      total += data['nominal'];
    }
    setState(() {
      totalPemasukan = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rangkuman Bulan Ini'),
      ),
      body: Column(
        children: <Widget>[
          // Informasi total pengeluaran (berwarna merah)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pengeluaran: \$${totalPengeluaran.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'Pemasukan: \$${totalPemasukan.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          // Gambar di luar GridView, posisi tengah horizontal
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20.0), // Sesuaikan dengan kebutuhan
            child: Image.asset(
              'assets/chart.png', // Ganti dengan path gambar Anda
              width: 350.0, // Sesuaikan dengan ukuran gambar Anda
            ),
          ),
          Expanded(
            child: Center(
              child: GridView.count(
                crossAxisCount: 2, // Jumlah kolom
                mainAxisSpacing: 16.0, // Spasi antara baris
                crossAxisSpacing: 16.0, // Spasi antara kolom
                padding: EdgeInsets.all(25.0),
                children: <Widget>[
                  MenuCard(
                    title: 'Tambah Pemasukan',
                    imageAsset: 'assets/profit.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TambahPemasukanPage()),
                      );
                    },
                  ),
                  MenuCard(
                    title: 'Tambah Pengeluaran',
                    imageAsset: 'assets/expenses.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TambahPengeluaranPage()),
                      );
                    },
                  ),
                  MenuCard(
                    title: 'Detail Cash Flow',
                    imageAsset: 'assets/flow.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CashFlowPage()),
                      );
                    },
                  ),
                  MenuCard(
                    title: 'Pengaturan',
                    imageAsset: 'assets/setting.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingPage()),
                      );

                      // Tambahkan logika untuk pindah ke halaman Pengaturan
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final VoidCallback onPressed;

  MenuCard({
    required this.title,
    required this.imageAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gambar di tengah secara horizontal dan vertikal
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                imageAsset,
                height: 80.0, // Sesuaikan dengan ukuran gambar Anda
                width: 80.0, // Sesuaikan dengan ukuran gambar Anda
              ),
            ),
            SizedBox(height: 8.0),
            // Judul di tengah secara horizontal
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center, // Teks di tengah secara horizontal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
