import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'course_models.dart';
import 'course_repository.dart';

Future<bool> showCourseFormDialog({
  required BuildContext context,
  required CourseRepository repository,
  CourseRecord? course,
}) async {
  final isEditing = course != null;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text: course?.title ?? '');
  final descriptionController = TextEditingController(
    text: course?.description ?? '',
  );
  final overviewController =
      TextEditingController(text: course?.overview ?? '');
  final outcomesController = TextEditingController(
    text: course?.outcomes.join('\n') ?? '',
  );
  final instructorController = TextEditingController(
    text: course?.instructorID == 'No instructor' ? '' : course?.instructorID,
  );

  final didSave = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      var isSaving = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
              ),
            ),
            title: Row(
              children: [
                Icon(
                  isEditing
                      ? Icons.edit_rounded
                      : Icons.add_circle_outline_rounded,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 10),
                Text(
                  isEditing ? 'Edit Course' : 'Add Course',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: SizedBox(
              width: min(MediaQuery.of(context).size.width - 48, 460),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CourseTextField(
                        controller: titleController,
                        enabled: !isSaving,
                        label: 'Title',
                        icon: Icons.menu_book_rounded,
                        validatorText: 'Enter a course title',
                      ),
                      const SizedBox(height: 14),
                      _CourseTextField(
                        controller: descriptionController,
                        enabled: !isSaving,
                        label: 'Short Description',
                        icon: Icons.notes_rounded,
                        minLines: 2,
                        maxLines: 4,
                        validatorText: 'Enter a course description',
                      ),
                      const SizedBox(height: 14),
                      _CourseTextField(
                        controller: overviewController,
                        enabled: !isSaving,
                        label: 'Course Overview',
                        icon: Icons.article_rounded,
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 14),
                      _CourseTextField(
                        controller: outcomesController,
                        enabled: !isSaving,
                        label: 'Module Outcomes',
                        icon: Icons.check_circle_outline_rounded,
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 14),
                      _CourseTextField(
                        controller: instructorController,
                        enabled: !isSaving,
                        label: 'Instructor ID',
                        icon: Icons.person_rounded,
                        validatorText: 'Enter an instructor ID',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    isSaving ? null : () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: isSaving
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isSaving = true);

                        try {
                          await repository.saveCourse(
                            CourseFormData(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              overview: overviewController.text.trim(),
                              outcomes: splitMultiline(
                                outcomesController.text,
                              ),
                              instructorID: instructorController.text.trim(),
                            ),
                            existingCourse: course,
                          );

                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop(true);
                          }
                        } catch (_) {
                          setDialogState(() => isSaving = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Something went wrong while saving the course',
                                ),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          }
                        }
                      },
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(isEditing ? Icons.save_rounded : Icons.add),
                label: Text(isEditing ? 'Save' : 'Add'),
              ),
            ],
          );
        },
      );
    },
  );

  titleController.dispose();
  descriptionController.dispose();
  overviewController.dispose();
  outcomesController.dispose();
  instructorController.dispose();

  return didSave == true;
}

class _CourseTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  final IconData icon;
  final int minLines;
  final int maxLines;
  final String? validatorText;

  const _CourseTextField({
    required this.controller,
    required this.enabled,
    required this.label,
    required this.icon,
    this.minLines = 1,
    this.maxLines = 1,
    this.validatorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label: label, icon: icon),
      validator: validatorText == null
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) {
                return validatorText;
              }
              return null;
            },
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIcon: Icon(icon, color: AppColors.primaryBlue),
    filled: true,
    fillColor: AppColors.background.withValues(alpha: 0.75),
    errorStyle: const TextStyle(color: Colors.orangeAccent),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: AppColors.primaryBlue.withValues(alpha: 0.2),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryBlue),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.orangeAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.orangeAccent),
    ),
  );
}
