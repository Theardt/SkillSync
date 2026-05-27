import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFirestore() async {
  final achievements = [
    {
      "achievementID": "ACH001",
      "badgeName": "Quick Learner",
      "dateEarned": "2026-01-15",
      "points": 120,
      "UserID": "USR001",
    },
    {
      "achievementID": "ACH002",
      "badgeName": "Quiz Master",
      "dateEarned": "2026-02-10",
      "points": 200,
      "UserID": "USR002",
    },
  ];

  final assessmentAttempts = [
    {
      "assessmentID": "ASM001",
      "attemptDate": "2026-03-01",
      "attemptID": "ATT001",
      "progressID": "PRG001",
      "score": 85,
    },
    {
      "assessmentID": "ASM002",
      "attemptDate": "2026-03-05",
      "attemptID": "ATT002",
      "progressID": "PRG002",
      "score": 72,
    },
  ];

  final assessments = [
    {
      "assessmentID": "ASM001",
      "isDeleted": false,
      "passingScore": 50,
      "sectionID": "SEC001",
      "title": "Introduction Quiz",
    },
    {
      "assessmentID": "ASM002",
      "isDeleted": false,
      "passingScore": 60,
      "sectionID": "SEC002",
      "title": "Programming Basics Test",
    },
  ];

  final courses = [
    {
      "courseID": "CRS001",
      "createdDate": "2026-01-01",
      "description":
          "Learn basic computer literacy and digital skills.",
      "instructorID": "USR003",
      "isDeleted": false,
      "title": "Computer skills",
    },
    {
      "courseID": "CRS002",
      "createdDate": "2026-01-02",
      "description":
          "Introduction to programming concepts and logic.",
      "instructorID": "USR003",
      "isDeleted": false,
      "title": "Introduction to programming",
    },
    {
      "courseID": "CRS003",
      "createdDate": "2026-01-03",
      "description":
          "Learn procedural programming fundamentals.",
      "instructorID": "USR003",
      "isDeleted": false,
      "title": "Procedural programming",
    },
    {
      "courseID": "CRS004",
      "createdDate": "2026-01-04",
      "description":
          "Learn object-oriented programming using C#.",
      "instructorID": "USR004",
      "isDeleted": false,
      "title": "C# Programming",
    },
    {
      "courseID": "CRS005",
      "createdDate": "2026-01-05",
      "description":
          "Comprehensive Java programming course.",
      "instructorID": "USR004",
      "isDeleted": false,
      "title": "Java Programming",
    },
    {
      "courseID": "CRS006",
      "createdDate": "2026-01-06",
      "description":
          "Learn Python programming from beginner to advanced.",
      "instructorID": "USR004",
      "isDeleted": false,
      "title": "Python Programming",
    },
    {
      "courseID": "CRS007",
      "createdDate": "2026-01-07",
      "description":
          "Introduction to database concepts and SQL.",
      "instructorID": "USR003",
      "isDeleted": false,
      "title": "Database Management",
    },
  ];

  final enrollments = [
    {
      "courseID": "CRS001",
      "enrollmentDate": "2026-02-01",
      "enrollmentID": "ENR001",
      "isActive": true,
      "userID": "USR001",
    },
    {
      "courseID": "CRS006",
      "enrollmentDate": "2026-02-03",
      "enrollmentID": "ENR002",
      "isActive": true,
      "userID": "USR002",
    },
  ];

  final feedback = [
    {
      "comments":
          "Very informative and beginner friendly.",
      "dateSubmitted": "2026-03-10",
      "difficultyFeedback": "Easy",
      "feedbackID": "FDB001",
      "rating": 5,
      "sectionID": "SEC001",
      "userID": "USR001",
    },
    {
      "comments":
          "Good explanations but needs more examples.",
      "dateSubmitted": "2026-03-12",
      "difficultyFeedback": "Medium",
      "feedbackID": "FDB002",
      "rating": 4,
      "sectionID": "SEC002",
      "userID": "USR002",
    },
  ];

  final modules = [
    {
      "courseID": "CRS001",
      "difficultyLevel": "Beginner",
      "estimatedTimeMinutes": 90,
      "isDeleted": false,
      "moduleID": "MOD001",
      "title": "Computer Basics",
    },
    {
      "courseID": "CRS006",
      "difficultyLevel": "Intermediate",
      "estimatedTimeMinutes": 120,
      "isDeleted": false,
      "moduleID": "MOD002",
      "title": "Python Fundamentals",
    },
  ];

  final moduleSections = [
    {
      "contentType": "Video",
      "estimatedTimeMinutes": 20,
      "isDeleted": false,
      "moduleID": "MOD001",
      "orderNumber": 1,
      "sectionID": "SEC001",
      "title": "Introduction to Computers",
    },
    {
      "contentType": "Article",
      "estimatedTimeMinutes": 30,
      "isDeleted": false,
      "moduleID": "MOD002",
      "orderNumber": 1,
      "sectionID": "SEC002",
      "title": "Variables and Data Types",
    },
  ];

  final progress = [
    {
      "adjustedDifficulty": 2,
      "completionStatus": 80,
      "enrollmentID": "ENR001",
      "lastUpdated": "2026-03-15",
      "progressID": "PRG001",
      "sectionID": "SEC001",
      "timeSpentMinutes": 75,
    },
    {
      "adjustedDifficulty": 3,
      "completionStatus": 60,
      "enrollmentID": "ENR002",
      "lastUpdated": "2026-03-18",
      "progressID": "PRG002",
      "sectionID": "SEC002",
      "timeSpentMinutes": 50,
    },
  ];

  final quizQuestions = [
    {
      "assessmentID": "ASM001",
      "explanation":
          "A computer processes and stores information.",
      "isDeleted": false,
      "questionID": "QST001",
      "questionText":
          "What is the primary function of a computer?",
    },
    {
      "assessmentID": "ASM002",
      "explanation":
          "Variables are used to store data.",
      "isDeleted": false,
      "questionID": "QST002",
      "questionText":
          "What is a variable in programming?",
    },
  ];

  final questionOptions = [
    {
      "isCorrect": true,
      "optionID": "OPT001",
      "optionText": "To process data",
      "questionID": "QST001",
    },
    {
      "isCorrect": false,
      "optionID": "OPT002",
      "optionText": "To cook food",
      "questionID": "QST001",
    },
    {
      "isCorrect": true,
      "optionID": "OPT003",
      "optionText":
          "A storage location for data",
      "questionID": "QST002",
    },
    {
      "isCorrect": false,
      "optionID": "OPT004",
      "optionText": "A type of hardware",
      "questionID": "QST002",
    },
  ];

  final users = [
    {
      "createdDate": "2026-01-01",
      "email": "john.doe@example.com",
      "fullName": "John Doe",
      "isDeleted": false,
      "lastLogin": "2026-03-20",
      "passwordHash": "hashed_password_001",
      "role": "Student",
      "userID": "USR001",
    },
    {
      "createdDate": "2026-01-02",
      "email": "jane.smith@example.com",
      "fullName": "Jane Smith",
      "isDeleted": false,
      "lastLogin": "2026-03-22",
      "passwordHash": "hashed_password_002",
      "role": "Student",
      "userID": "USR002",
    },
    {
      "createdDate": "2026-01-03",
      "email": "instructor.one@example.com",
      "fullName": "Michael Adams",
      "isDeleted": false,
      "lastLogin": "2026-03-23",
      "passwordHash": "hashed_password_003",
      "role": "Instructor",
      "userID": "USR003",
    },
    {
      "createdDate": "2026-01-04",
      "email": "instructor.two@example.com",
      "fullName": "Sarah Johnson",
      "isDeleted": false,
      "lastLogin": "2026-03-24",
      "passwordHash": "hashed_password_004",
      "role": "Instructor",
      "userID": "USR004",
    },
  ];

  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  void addCollection(
    String collectionName,
    List<Map<String, dynamic>> data,
    String idField,
  ) {
    for (final item in data) {
      final docRef = firestore
          .collection(collectionName)
          .doc(item[idField]);

      batch.set(docRef, item);
    }
  }

  addCollection(
      "Achievements", achievements, "achievementID");
  addCollection(
      "AssessmentAttempts",
      assessmentAttempts,
      "attemptID");
  addCollection(
      "Assessments", assessments, "assessmentID");
  addCollection("Courses", courses, "courseID");
  addCollection(
      "Enrollment", enrollments, "enrollmentID");
  addCollection("Feedback", feedback, "feedbackID");
  addCollection("Modules", modules, "moduleID");
  addCollection(
      "ModuleSections",
      moduleSections,
      "sectionID");
  addCollection("Progress", progress, "progressID");
  addCollection(
      "QuizQuestions",
      quizQuestions,
      "questionID");
  addCollection(
      "QuestionOptions",
      questionOptions,
      "optionID");
  addCollection("Users", users, "userID");

  await batch.commit();

  print("Firestore seeded successfully!");
}