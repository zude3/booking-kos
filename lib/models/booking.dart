class Booking {
  final int kosId;
  final String namaKos;
  final DateTime tanggalMasuk;
  final int durasiBulan;
  final int totalHarga;
  final String status;
  final String? catatan;

  const Booking({
    required this.kosId,
    required this.namaKos,
    required this.tanggalMasuk,
    required this.durasiBulan,
    required this.totalHarga,
    this.status = 'Menunggu Pembayaran',
    required this.catatan
  });
}
