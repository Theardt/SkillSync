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
  final didSave = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _CourseFormDialog(
      repository: repository,
      course: course,
    ),
  );

  return didSave == true;
}

class _CourseFormDialog extends StatefulWidget {
  final CourseRepository repository;
  final CourseRecord? course;

  const _CourseFormDialog({
    required this.repository,
    this.course,
  });

  @override
  State<_CourseFormDialog> createState() => _CourseFormDialogState();
}

class _CourseFormDialogState extends State<_CourseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _overview;
  late String _outcomes;
  late String _instructorID;
  var _isSaving = false;

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    final course = widget.course;
    _title = course?.title ?? '';
    _description = course?.description ?? '';
    _overview = course?.overview ?? '';
    _outcomes = course?.outcomes.join('\n') ?? '';
    _instructorID = course?.instructorID == 'No instructor'
        ? ''
        : course?.instructorID ?? '';
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      await widget.repository.saveCourse(
        CourseFormData(
          title: _title.trim(),
          description: _description.trim(),
          overview: _overview.trim(),
          outcomes: splitMultiline(_outcomes),
          instructorID: _instructorID.trim(),
        ),
        existingCourse: widget.course,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong while saving the course'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _isEditing ? Icons.edit_rounded : Icons.add_circle_outline_rounded,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 10),
          Text(
            _isEditing ? 'Edit Course' : 'Add Course',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      content: SizedBox(
        width: min(MediaQuery.of(context).size.width - 48, 460),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CourseTextField(
                  initialValue: _title,
                  onSaved: (value) => _title = value ?? '',
                  enabled: !_isSaving,
                  label: 'Title',
                  icon: Icons.menu_book_rounded,
                  validatorText: 'Enter a course title',
                ),
                const SizedBox(height: 14),
                _CourseTextField(
                  initialValue: _description,
                  onSaved: (value) => _description = value ?? '',
                  enabled: !_isSaving,
                  label: 'Short Description',
                  icon: Icons.notes_rounded,
                  minLines: 2,
                  maxLines: 4,
                  validatorText: 'Enter a course description',
                ),
                const SizedBox(height: 14),
                _CourseTextField(
                  initialValue: _overview,
                  onSaved: (value) => _overview = value ?? '',
                  enabled: !_isSaving,
                  label: 'Course Overview',
                  icon: Icons.article_rounded,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _CourseTextField(
                  initialValue: _outcomes,
                  onSaved: (value) => _outcomes = value ?? '',
                  enabled: !_isSaving,
                  label: 'Module Outcomes',
                  icon: Icons.check_circle_outline_rounded,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 14),
                _CourseTextField(
                  initialValue: _instructorID,
                  onSaved: (value) => _instructorID = value ?? '',
                  enabled: !_isSaving,
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
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveCourse,
          icon: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_isEditing ? Icons.save_rounded : Icons.add),
          label: Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

class _CourseTextField extends StatelessWidget {
  final String initialValue;
  final FormFieldSetter<String> onSaved;
  final bool enabled;
  final String label;
  final IconData icon;
  final int minLines;
  final int maxLines;
  final String? validatorText;

  const _CourseTextField({
    required this.initialValue,
    required this.onSaved,
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
      initialValue: initialValue,
      onSaved: onSaved,
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
