import 'package:flutter/material.dart';

import '../models/kos.dart';
import '../data/dummy_kos.dart';
import 'detail_screen.dart';
import '../widgets/kos_foto.dart';

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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final penuh = kos.kamarTersedia == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(kos: kos)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KosFoto(kos: kos),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kos.nama, style: tt.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          kos.alamat,
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${kos.hargaPerBulan} / bulan',
                          style: tt.labelLarge?.copyWith(color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(penuh ? 'Penuh' : '${kos.kamarTersedia} kamar'),
                    backgroundColor: penuh
                        ? cs.errorContainer
                        : cs.secondaryContainer,
                    labelStyle: TextStyle(
                      color: penuh
                          ? cs.onErrorContainer
                          : cs.onSecondaryContainer,
                    ),
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
