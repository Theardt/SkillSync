import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'course_card.dart';
import 'course_detail_sheet.dart';
import 'course_form_dialog.dart';
import 'course_models.dart';
import 'course_repository.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  final CourseRepository _repository = CourseRepository();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showCourseForm({CourseRecord? course}) async {
    final didSave = await showCourseFormDialog(
      context: context,
      repository: _repository,
      course: course,
    );

    if (!mounted || !didSave) return;
    _showSnackBar(
      course == null
          ? 'Course added successfully'
          : 'Course updated successfully',
    );
  }

  Future<void> _confirmDelete(CourseRecord course) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.red.withValues(alpha: 0.35)),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: AppColors.red),
              SizedBox(width: 10),
              Text('Delete Course', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            'Delete "${course.title}"?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_rounded),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await _repository.softDeleteCourse(course);
      if (!mounted) return;
      _showSnackBar('Course deleted successfully');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(
        'Something went wrong while deleting the course',
        isError: true,
      );
    }
  }

  void _showCourseDetails(CourseRecord course) {
    showCourseDetailSheet(
      context: context,
      course: course,
      contentFuture: _repository.loadCourseContent(course.courseID),
    );
  }

  Widget _buildHeader({
    required bool isMobile,
    required double titleSize,
  }) {
    final title = Text(
      'Available Courses',
      style: TextStyle(
        color: Colors.white,
        fontSize: titleSize + 6,
        fontWeight: FontWeight.bold,
      ),
    );

    final addButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _showCourseForm(),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Course'),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: addButton),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: title),
        addButton,
      ],
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.red : AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;
    final horizontalPadding = isMobile
        ? 16.0
        : isTablet
            ? 20.0
            : 28.0;
    final titleSize = isMobile ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile: isMobile, titleSize: titleSize),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<List<CourseRecord>>(
                      stream: _repository.watchCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Error loading courses',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        final courses = snapshot.data ?? [];

                        if (courses.isEmpty) {
                          return const Center(
                            child: Text(
                              'No courses found.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return CourseCard(
                              course: course,
                              isMobile: isMobile,
                              onView: () => _showCourseDetails(course),
                              onEdit: () => _showCourseForm(course: course),
                              onDelete: () => _confirmDelete(course),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
