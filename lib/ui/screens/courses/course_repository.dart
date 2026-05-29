import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_models.dart';

class CourseRepository {
  final CollectionReference<Map<String, dynamic>> _coursesCollection =
      FirebaseFirestore.instance.collection('Courses');
  final CollectionReference<Map<String, dynamic>> _modulesCollection =
      FirebaseFirestore.instance.collection('Modules');
  final CollectionReference<Map<String, dynamic>> _moduleSectionsCollection =
      FirebaseFirestore.instance.collection('ModuleSections');

  Stream<List<CourseRecord>> watchCourses() {
    return _coursesCollection.snapshots().map((snapshot) {
      final courses = snapshot.docs
          .map(CourseRecord.fromDoc)
          .where((course) => !course.isDeleted)
          .toList()
        ..sort(_compareCourses);

      return courses;
    });
  }

  Future<void> saveCourse(
    CourseFormData formData, {
    CourseRecord? existingCourse,
  }) async {
    final payload = formData.toPayload();

    if (existingCourse != null) {
      await _coursesCollection.doc(existingCourse.docId).update(payload);
      return;
    }

    final courseID = await _generateNextCourseId();
    await _coursesCollection.doc(courseID).set({
      ...payload,
      'courseID': courseID,
      'createdDate': _todayString(),
    });
  }

  Future<void> softDeleteCourse(CourseRecord course) async {
    await _coursesCollection.doc(course.docId).update({'isDeleted': true});
  }

  Future<CourseContent> loadCourseContent(String courseID) async {
    final moduleSnapshot =
        await _modulesCollection.where('courseID', isEqualTo: courseID).get();

    final moduleDocs = moduleSnapshot.docs
        .where((module) => module.data()['isDeleted'] != true)
        .toList();

    final modules = await Future.wait(
      moduleDocs.map((moduleDoc) async {
        final moduleData = moduleDoc.data();
        final moduleID = moduleData['moduleID']?.toString() ?? moduleDoc.id;
        final sectionSnapshot = await _moduleSectionsCollection
            .where('moduleID', isEqualTo: moduleID)
            .get();

        final sections = sectionSnapshot.docs
            .where((section) => section.data()['isDeleted'] != true)
            .map((section) {
          final sectionData = section.data();
          return CourseSection(
            title: sectionData['title']?.toString() ?? 'Untitled section',
            contentType: sectionData['contentType']?.toString() ?? '',
            estimatedTimeMinutes: _readInt(sectionData['estimatedTimeMinutes']),
            orderNumber: _readInt(sectionData['orderNumber']),
          );
        }).toList()
          ..sort(_compareCourseSections);

        return CourseModule(
          moduleID: moduleID,
          title: moduleData['title']?.toString() ?? 'Untitled module',
          difficultyLevel: moduleData['difficultyLevel']?.toString() ?? '',
          estimatedTimeMinutes: _readInt(moduleData['estimatedTimeMinutes']),
          orderNumber: _readInt(moduleData['orderNumber']),
          sections: sections,
        );
      }),
    );

    modules.sort(_compareCourseModules);
    return CourseContent(modules: modules);
  }

  Future<String> _generateNextCourseId() async {
    final snapshot = await _coursesCollection.get();
    var highestNumber = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final courseID = data['courseID']?.toString() ?? doc.id;
      final match = RegExp(r'^CRS(\d+)$').firstMatch(courseID);
      if (match == null) continue;

      highestNumber = max(
        highestNumber,
        int.tryParse(match.group(1) ?? '') ?? 0,
      );
    }

    return 'CRS${(highestNumber + 1).toString().padLeft(3, '0')}';
  }

  String _todayString() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  int _compareCourses(CourseRecord first, CourseRecord second) {
    final firstNumber =
        int.tryParse(RegExp(r'\d+').firstMatch(first.courseID)?.group(0) ?? '');
    final secondNumber = int.tryParse(
      RegExp(r'\d+').firstMatch(second.courseID)?.group(0) ?? '',
    );

    if (firstNumber != null && secondNumber != null) {
      return firstNumber.compareTo(secondNumber);
    }

    return first.courseID.compareTo(second.courseID);
  }

  int _compareCourseModules(CourseModule first, CourseModule second) {
    final orderCompare = _compareNullableOrder(
      first.orderNumber,
      second.orderNumber,
    );
    if (orderCompare != 0) return orderCompare;
    return first.title.compareTo(second.title);
  }

  int _compareCourseSections(CourseSection first, CourseSection second) {
    final orderCompare = _compareNullableOrder(
      first.orderNumber,
      second.orderNumber,
    );
    if (orderCompare != 0) return orderCompare;
    return first.title.compareTo(second.title);
  }

  int _compareNullableOrder(int? first, int? second) {
    if (first != null && second != null && first != second) {
      return first.compareTo(second);
    }
    if (first != null && second == null) return -1;
    if (first == null && second != null) return 1;
    return 0;
  }

  int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
