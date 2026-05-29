import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'course_models.dart';

void showCourseDetailSheet({
  required BuildContext context,
  required CourseRecord course,
  required Future<CourseContent> contentFuture,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final sheetWidth = min(
        MediaQuery.of(sheetContext).size.width - 24,
        860.0,
      );

      return DraggableScrollableSheet(
        initialChildSize: 0.86,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (context, scrollController) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: sheetWidth),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                  children: [
                    const _SheetHandle(),
                    const SizedBox(height: 18),
                    _SheetTitle(
                      title: course.title,
                      onClose: () => Navigator.of(sheetContext).pop(),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _DetailChip(Icons.tag_rounded, course.courseID),
                        _DetailChip(
                          Icons.trending_up_rounded,
                          'Progress: ${course.progressLabel}',
                        ),
                        _DetailChip(
                          Icons.person_rounded,
                          'Instructor: ${course.instructorID}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Course Overview',
                      child: Text(
                        course.overview.isNotEmpty
                            ? course.overview
                            : course.description,
                        style: _bodyTextStyle,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Module Content',
                      child: FutureBuilder<CourseContent>(
                        future: contentFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text(
                              'Could not load module content.',
                              style: TextStyle(color: Colors.white70),
                            );
                          }

                          return _ModuleContent(
                            courseID: course.courseID,
                            content: snapshot.data ??
                                const CourseContent(modules: []),
                          );
                        },
                      ),
                    ),
                    if (course.outcomes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _DetailSection(
                        title: 'Module Outcomes',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: course.outcomes
                              .map((outcome) => _ContentLine(outcome))
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

const _bodyTextStyle = TextStyle(
  color: Colors.white70,
  fontSize: 15,
  height: 1.45,
);

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _SheetTitle({
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
          color: Colors.white70,
          tooltip: 'Close',
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _ModuleContent extends StatelessWidget {
  final String courseID;
  final CourseContent content;

  const _ModuleContent({
    required this.courseID,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.modules.isEmpty) {
      return Text(
        'No module content has been added for $courseID yet.',
        style: _bodyTextStyle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < content.modules.length; index++)
          _ModuleBlock(content.modules[index], index + 1),
      ],
    );
  }
}

class _ModuleBlock extends StatelessWidget {
  final CourseModule module;
  final int number;

  const _ModuleBlock(this.module, this.number);

  @override
  Widget build(BuildContext context) {
    final details = <String>[
      module.moduleID,
      if (module.difficultyLevel.isNotEmpty) module.difficultyLevel,
      if (module.estimatedTimeMinutes != null)
        '${module.estimatedTimeMinutes} min',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModuleNumber(number),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    details.join(' - '),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if (module.sections.isEmpty)
                  const Text(
                    'No sections added yet.',
                    style: TextStyle(color: Colors.white54),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: module.sections
                        .map((section) => _SectionLine(section))
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleNumber extends StatelessWidget {
  final int number;

  const _ModuleNumber(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SectionLine extends StatelessWidget {
  final CourseSection section;

  const _SectionLine(this.section);

  @override
  Widget build(BuildContext context) {
    final details = <String>[
      if (section.contentType.isNotEmpty) section.contentType,
      if (section.estimatedTimeMinutes != null)
        '${section.estimatedTimeMinutes} min',
    ];

    return _ContentLine(
      section.title,
      detail: details.join(' - '),
    );
  }
}

class _ContentLine extends StatelessWidget {
  final String text;
  final String detail;

  const _ContentLine(this.text, {this.detail = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(
              Icons.circle,
              color: AppColors.primaryBlue,
              size: 6,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: _bodyTextStyle),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
