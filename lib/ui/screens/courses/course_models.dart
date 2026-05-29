import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRecord {
  final String docId;
  final String courseID;
  final String title;
  final String description;
  final String overview;
  final List<String> outcomes;
  final String instructorID;
  final String progressLabel;
  final bool isDeleted;

  const CourseRecord({
    required this.docId,
    required this.courseID,
    required this.title,
    required this.description,
    required this.overview,
    required this.outcomes,
    required this.instructorID,
    required this.progressLabel,
    required this.isDeleted,
  });

  factory CourseRecord.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return CourseRecord(
      docId: doc.id,
      courseID: data['courseID']?.toString() ?? doc.id,
      title: data['title']?.toString() ?? 'Untitled Course',
      description:
          data['description']?.toString() ?? 'No description available.',
      overview: data['overview']?.toString().trim() ?? '',
      outcomes: readStringList(data['outcomes']),
      instructorID: data['instructorID']?.toString() ?? 'No instructor',
      progressLabel: _progressLabel(data),
      isDeleted: data['isDeleted'] == true,
    );
  }

  static String _progressLabel(Map<String, dynamic> data) {
    final value = data['progress'] ?? data['completionStatus'];
    if (value is num) return '${value.round()}%';

    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return 'Not started';
    return text;
  }
}

class CourseFormData {
  final String title;
  final String description;
  final String overview;
  final List<String> outcomes;
  final String instructorID;

  const CourseFormData({
    required this.title,
    required this.description,
    required this.overview,
    required this.outcomes,
    required this.instructorID,
  });

  Map<String, dynamic> toPayload() {
    return {
      'title': title,
      'description': description,
      'overview': overview,
      'outcomes': outcomes,
      'instructorID': instructorID,
      'isDeleted': false,
    };
  }
}

class CourseContent {
  final List<CourseModule> modules;

  const CourseContent({required this.modules});
}

class CourseModule {
  final String moduleID;
  final String title;
  final String difficultyLevel;
  final int? estimatedTimeMinutes;
  final int? orderNumber;
  final List<CourseSection> sections;

  const CourseModule({
    required this.moduleID,
    required this.title,
    required this.difficultyLevel,
    required this.estimatedTimeMinutes,
    required this.orderNumber,
    required this.sections,
  });
}

class CourseSection {
  final String title;
  final String contentType;
  final int? estimatedTimeMinutes;
  final int? orderNumber;

  const CourseSection({
    required this.title,
    required this.contentType,
    required this.estimatedTimeMinutes,
    required this.orderNumber,
  });
}

List<String> readStringList(dynamic value) {
  if (value is Iterable) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  if (value is String) return splitMultiline(value);
  return [];
}

List<String> splitMultiline(String value) {
  return value
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}
