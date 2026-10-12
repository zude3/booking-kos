import 'package:flutter/material.dart';

import '../models/kos.dart';

class KosFoto extends StatelessWidget{
  final Kos kos;
  final double aspectRatio;

  const KosFoto({super.key, required this.kos, this.aspectRatio = 16 / 9});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Hero(
        tag: 'foto-${kos.id}',
        child: Image.asset(
          kos.foto,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: cs.surfaceContainerHighest,
            child: Icon(Icons.image_not_supported_outlined,
                color: cs.onSurfaceVariant),
          ),
        ),
      ),
    );
  }  
}