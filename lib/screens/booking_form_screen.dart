import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/kos.dart';
import '../models/booking.dart';

class BookingFormScreen extends StatefulWidget {
  final Kos kos; // DATA YANG DITERIMA dari DetailScreen

  const BookingFormScreen({super.key, required this.kos});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _durasiController = TextEditingController();
  final _catatanController = TextEditingController();

  DateTime? _tanggalMasuk;
  int _durasi = 0;
  bool _isLoading = false;

  int get _totalHarga => _durasi * widget.kos.hargaPerBulan;

  @override
  void dispose() {
    _tanggalController.dispose();
    _durasiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hariIni = DateTime.now();
    final hasil = await showDatePicker(
      context: context,
      initialDate: hariIni,
      firstDate: hariIni,
      lastDate: hariIni.add(const Duration(days: 365)),
    );
    if (hasil != null) {
      setState(() {
        _tanggalMasuk = hasil;
        _tanggalController.text = '${hasil.day}/${hasil.month}/${hasil.year}';
      });
    }
  }

  static const bool _simulasiGagal = false;

  Future<void> _kirimBooking() async {
    // await Future.delayed(const Duration(seconds: 2)); // pura-pura loading
    if (_simulasiGagal) {
      throw Exception('Koneksi ke server gagal');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = false);

    try {
      await _kirimBooking();

      final booking = Booking(
        kosId: widget.kos.id,
        namaKos: widget.kos.nama,
        tanggalMasuk: _tanggalMasuk!,
        durasiBulan: _durasi,
        totalHarga: _totalHarga,
        catatan: _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, booking);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking gagal: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kos = widget.kos;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kos.nama, style: Theme.of(context).textTheme.titleLarge),
              Text('Rp ${kos.hargaPerBulan} / bulan'),
              const SizedBox(height: 24),

              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal masuk',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pilihTanggal,
                validator: (value) {
                  if (_tanggalMasuk == null) {
                    return 'Tanggal masuk wajib dipilih';
                  }
                  return null; // null = valid
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durasiController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Durasi sewa (bulan)',
                ),
                onChanged: (value) {
                  setState(() {
                    _durasi = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi wajib diisi';
                  }
                  final angka = int.tryParse(value);
                  if (angka == null || angka < 1) {
                    return 'Durasi minimal 1 bulan';
                  }
                  if (angka > 12) {
                    return 'Durasi maksimal 12 bulan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                ),
              ),

              const SizedBox(height: 24),

              // STATE yang tampil: total harga
              Text(
                'Total: Rp $_totalHarga',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Ajukan Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
