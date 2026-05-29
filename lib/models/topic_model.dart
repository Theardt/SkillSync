class TopicModel {
  final String? id; // Firestore Document ID
  final String moduleTitle;
  final String topicTitle;
  final String content;
  final String? codeExample; // Nullable if a topic doesn't have code
  final String? activity;    // Nullable if a topic doesn't have an activity

  TopicModel({
    this.id,
    required this.moduleTitle,
    required this.topicTitle,
    required this.content,
    this.codeExample,
    this.activity,
  });

  // Convert a Dart Object into a Map to write to Firestore
  Map<String, dynamic> toMap() {
    return {
      'moduleTitle': moduleTitle,
      'topicTitle': topicTitle,
      'content': content,
      'codeExample': codeExample,
      'activity': activity,
    };
  }

  // Convert a Firestore Map Document back into a Dart Object
  factory TopicModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TopicModel(
      id: documentId,
      moduleTitle: map['moduleTitle'] ?? '',
      topicTitle: map['topicTitle'] ?? '',
      content: map['content'] ?? '',
      codeExample: map['codeExample'],
      activity: map['activity'],
    );
  }
}