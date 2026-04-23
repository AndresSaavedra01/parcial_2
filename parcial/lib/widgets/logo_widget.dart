import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class LogoWidget extends StatelessWidget {
  final String? logoUrl;
  final double size;

  const LogoWidget({
    super.key,
    required this.logoUrl,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          logoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _skeleton();
          },
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(
        Icons.store_rounded,
        color: AppTheme.primary,
        size: size * 0.5,
      ),
    );
  }

  Widget _skeleton() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(size / 4),
      ),
    );
  }
}
