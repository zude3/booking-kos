import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../data/dummy_kos.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Kos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyKos.length,
        itemBuilder: (context, index) {
          final kos = dummyKos[index];
          return _KosCard(kos: kos);
        },
      ),
    );
  }
}

class _KosCard extends StatelessWidget {
  final Kos kos;
  const _KosCard({required this.kos});

  @override
  Widget build(BuildContext context) {
    final penuh = kos.kamarTersedia == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(kos.nama),
        subtitle: Text('${kos.alamat}\nRp ${kos.hargaPerBulan} / bulan'),
        isThreeLine: true,
        trailing: Text(
          penuh ? 'Penuh' : '${kos.kamarTersedia} kamar',
          style: TextStyle(color: penuh ? Colors.red : Colors.green),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(kos: kos)),
          );
        },
      ),
    );
  }
}
