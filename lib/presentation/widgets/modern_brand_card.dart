import 'package:flutter/material.dart';
import '../../domain/entities/brand.dart';
import '../../core/theme/app_theme.dart';

class ModernBrandCard extends StatelessWidget {
  final Brand brand;
  final bool isSelected;
  final VoidCallback onTap;

  const ModernBrandCard({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo con imagen o icono
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected 
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: ClipOval(
                child: brand.imageUrl != null
                    ? Image.network(
                        brand.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(context, isSelected);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildPlaceholder(context, isSelected);
                        },
                      )
                    : _buildPlaceholder(context, isSelected),
              ),
            ),
            const SizedBox(height: 8),
            // Nombre de la marca
            Text(
              brand.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected 
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
                  colorScheme.primary.withValues(alpha: 0.3),
                  colorScheme.primary.withValues(alpha: 0.1),
                ]
              : [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainer,
                ],
        ),
      ),
      child: Icon(
        Icons.local_offer,
        size: 24,
        color: isSelected 
            ? Colors.white 
            : colorScheme.primary.withValues(alpha: 0.7),
      ),
    );
  }
}