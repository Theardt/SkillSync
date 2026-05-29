import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'course_models.dart';

class CourseCard extends StatelessWidget {
  final CourseRecord course;
  final bool isMobile;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CourseCard({
    super.key,
    required this.course,
    required this.isMobile,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onView,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: isMobile ? 22 : 24,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${course.courseID} - ${course.instructorID}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _CardAction(
                tooltip: 'View course',
                icon: Icons.visibility_rounded,
                color: Colors.white70,
                onPressed: onView,
              ),
              _CardAction(
                tooltip: 'Edit course',
                icon: Icons.edit_rounded,
                color: Colors.white70,
                onPressed: onEdit,
              ),
              _CardAction(
                tooltip: 'Delete course',
                icon: Icons.delete_outline_rounded,
                color: AppColors.red.withValues(alpha: 0.9),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _CardAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: color,
      ),
    );
  }
}
