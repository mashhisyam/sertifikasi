import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'database.dart'; // Impor DatabaseHelper

class TambahPengeluaranPage extends StatefulWidget {
  @override
  _TambahPengeluaranPageState createState() => _TambahPengeluaranPageState();
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final int thousandSeparatorLength = 3;
    final String currencySymbol = 'Rp';
    final String zero = '0';

    String newText = newValue.text.replaceAll(currencySymbol, '');
    newText = newText.replaceAll(RegExp('[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(
        text: currencySymbol,
        selection: TextSelection.collapsed(offset: currencySymbol.length),
      );
    }

    final int rawValue = int.tryParse(newText) ?? 0;
    final String formattedValue =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
            .format(rawValue);

    return newValue.copyWith(
      text: '$currencySymbol$formattedValue',
      selection: TextSelection.collapsed(offset: formattedValue.length + currencySymbol.length),
    );
  }
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _keteranganController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _resetForm() {
    _nominalController.clear();
    _keteranganController.clear();
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _simpanPengeluaran() async {
    final nominal = _nominalController.text;
    final keterangan = _keteranganController.text;
    final tanggal = DateFormat('yyyy-MM-dd').format(_selectedDate);

    if (nominal.isEmpty || tanggal.isEmpty) {
      // Validasi input kosong
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Nominal dan tanggal harus diisi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final pengeluaran = {
      'tanggal': tanggal,
      'nominal': int.parse(nominal.replaceAll(RegExp('[^0-9]'), '')),
      'keterangan': keterangan,
    };

    final result = await DatabaseHelper.instance.insertPengeluaran(pengeluaran);

    if (result != 0) {
      // Data berhasil disimpan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sukses'),
            content: Text('Data pengeluaran berhasil disimpan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Data gagal disimpan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat menyimpan data pengeluaran.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengeluaran'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Tanggal: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                  style: TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  onPressed: () {
                    _showDatePicker(context);
                  },
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: InputDecoration(labelText: 'Nominal'),
            ),
            TextFormField(
              controller: _keteranganController,
              decoration: InputDecoration(labelText: 'Keterangan'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _resetForm,
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _simpanPengeluaran,
                  child: Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
