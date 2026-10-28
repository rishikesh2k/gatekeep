import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/widgets/status_chip.dart';
import 'package:gatekeep/widgets/visitor_avatar.dart';

class VisitorCard extends StatelessWidget {
  final Visitor visitor;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VisitorCard({
    super.key,
    required this.visitor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 6),
          child: Column(
            children: [
              Row(
                children: [
                  VisitorAvatar(name: visitor.name),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(visitor.mobile, style: TextStyle(color: subtle)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: StatusChip(status: visitor.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(child: CardTag(icon: Icons.apartment_outlined, text: visitor.project)),
                  const SizedBox(width: 8),
                  Flexible(child: CardTag(icon: Icons.badge_outlined, text: visitor.visitorType)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Edit',
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    tooltip: 'Delete',
                    color: AppColors.danger,
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const CardTag({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.5, color: color),
          ),
        ),
      ],
    );
  }
}
