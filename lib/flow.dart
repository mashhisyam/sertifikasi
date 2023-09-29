import 'package:flutter/material.dart';
import 'database.dart';

class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage> {
  Future<List<Map<String, dynamic>>> _pemasukanList =
      DatabaseHelper.instance.getPemasukan();
  Future<List<Map<String, dynamic>>> _pengeluaranList =
      DatabaseHelper.instance.getPengeluaran();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Flow'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _pemasukanList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data pemasukan.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var pemasukan = snapshot.data![index];
                      return _buildTransaksiCard(
                        'Pemasukan ${pemasukan['id']}',
                        '+Rp ${pemasukan['nominal']}',
                        'Tanggal: ${pemasukan['tanggal']}',
                        pemasukan['keterangan'],
                        Colors.green, // Warna panah hijau untuk pemasukan
                        Icons.arrow_left,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _pengeluaranList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data pengeluaran.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var pengeluaran = snapshot.data![index];
                      return _buildTransaksiCard(
                        'Pengeluaran ${pengeluaran['id']}',
                        '-Rp ${pengeluaran['nominal']}',
                        'Tanggal: ${pengeluaran['tanggal']}',
                        pengeluaran['keterangan'],
                        Colors.red, // Warna panah merah untuk pengeluaran
                        Icons.arrow_right,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiCard(
    String title,
    String nilai,
    String tanggal,
    String keterangan,
    Color arrowColor,
    IconData arrowIcon,
  ) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nilai,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: arrowColor,
              ),
            ),
            Text(
              tanggal,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            Text(
              keterangan,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        trailing: Icon(
          arrowIcon,
          color: arrowColor,
          size: 36.0,
        ),
      ),
    );
  }
}
