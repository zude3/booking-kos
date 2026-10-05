import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../models/booking.dart';
import 'booking_form_screen.dart';

class DetailScreen extends StatefulWidget {
  final Kos kos;

  const DetailScreen({super.key, required this.kos});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Booking? _bookingTerakhir;

  @override
  Widget build(BuildContext context) {
    final kos = widget.kos;
    final penuh = kos.kamarTersedia == 0;

    return Scaffold(
      appBar: AppBar(title: Text(kos.nama)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kos.nama, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(kos.alamat),
            const SizedBox(height: 8),
            Text('Rp ${kos.hargaPerBulan} / bulan'),
            const SizedBox(height: 8),
            Text(
              penuh ? 'Kamar penuh' : 'Kamar tersedia: ${kos.kamarTersedia}',
            ),
            const SizedBox(height: 24),

            if (_bookingTerakhir != null) _buildKartuBooking(_bookingTerakhir!),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: penuh ? null : _bukaFormBooking,
                child: Text(penuh ? 'Kamar Penuh' : 'Booking Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKartuBooking(Booking b) {
    return Card(
      color: Colors.green.shade50,
      child: ListTile(
        title: Text('Booking diajukan: ${b.durasiBulan} bulan'),
        subtitle: Text(
          'Total Rp ${b.totalHarga}\nStatus: ${b.status}\nCatatan: ${b.catatan}',
        ),
        isThreeLine: true,
      ),
    );
  }

  Future<void> _bukaFormBooking() async {
    final hasil = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(
        builder: (context) => BookingFormScreen(kos: widget.kos),
      ),
    );
    if (hasil != null) {
      setState(() => _bookingTerakhir = hasil);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil diajukan!')),
      );
    }
  }
}
