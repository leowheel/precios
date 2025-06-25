import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/subcategory.dart';
import '../../application/providers/category_providers.dart';

class HorizontalCategoryMenu extends ConsumerWidget {
  final String? selectedCategoryId;
  final String? selectedSubcategoryId;
  final Function(String)? onCategorySelected;
  final Function(String)? onSubcategorySelected;
  final VoidCallback? onClearFilters;

  const HorizontalCategoryMenu({
    super.key,
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.onCategorySelected,
    this.onSubcategorySelected,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (selectedCategoryId != null || selectedSubcategoryId != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_alt_off,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      onPressed: onClearFilters,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Limpiar',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ...categoriesAsync.when(
            data: (categories) => categories.map((category) {
              final isSelected = category.id == selectedCategoryId;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubcategoryPopupMenu(
                      category: category,
                      isSelected: isSelected,
                      selectedSubcategoryId: selectedSubcategoryId,
                      onCategorySelected: onCategorySelected,
                      onSubcategorySelected: onSubcategorySelected,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 72,
                      child: Text(
                        category.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (error, _) => [Center(child: Text('Error: $error'))],
          ),
        ],
      ),
    );
  }
}

class SubcategoryPopupMenu extends ConsumerWidget {
  final Category category;
  final bool isSelected;
  final String? selectedSubcategoryId;
  final Function(String)? onCategorySelected;
  final Function(String)? onSubcategorySelected;

  const SubcategoryPopupMenu({
    super.key,
    required this.category,
    required this.isSelected,
    this.selectedSubcategoryId,
    this.onCategorySelected,
    this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subcategoriesAsync = ref.watch(
      subcategoriesByCategoryProvider(category.id),
    );

    return GestureDetector(
      onTapDown: (details) async {
        if (onCategorySelected != null) {
          onCategorySelected!(category.id);
        }

        final subcategories = await ref.read(
          subcategoriesByCategoryProvider(category.id).future,
        );
        if (subcategories.isEmpty) return;

        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Navigator.of(context).overlay!.context.findRenderObject()
                as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(
              Offset(0, button.size.height),
              ancestor: overlay,
            ),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );

        await showMenu<String>(
          context: context,
          position: position,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          items: [
            ...subcategories.map((subcategory) {
              final isSubcategorySelected =
                  subcategory.id == selectedSubcategoryId;
              return PopupMenuItem<String>(
                value: subcategory.id,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSubcategorySelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_right,
                          size: 16,
                          color: isSubcategorySelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subcategory.name,
                        style: TextStyle(
                          color: isSubcategorySelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: isSubcategorySelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSubcategorySelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ).then((selectedId) {
          if (selectedId != null && onSubcategorySelected != null) {
            onSubcategorySelected!(selectedId);
          }
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceVariant,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                _getCategoryIcon(category.name),
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (isSelected)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final nameLower = categoryName.toLowerCase();
    if (nameLower.contains('bebida')) return Icons.local_drink;
    if (nameLower.contains('limpieza')) return Icons.cleaning_services;
    if (nameLower.contains('alimento')) return Icons.restaurant;
    if (nameLower.contains('hogar')) return Icons.home;
    if (nameLower.contains('personal')) return Icons.person;
    if (nameLower.contains('mascota')) return Icons.pets;
    return Icons.category;
  }
}
