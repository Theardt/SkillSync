import 'package:cloud_firestore/cloud_firestore.dart';

class StreakService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Call this function whenever a user completes their daily target/opens the app
  static Future<void> updateStreak(String userId) async {
    final userDocRef = _firestore.collection('users').doc(userId);

    // Use a transaction to ensure safe data reads and writes
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      
      // Extract current data values (defaulting to 0/empty if they don't exist yet)
      int currentStreak = data['currentStreak'] ?? 0;
      int longestStreak = data['longestStreak'] ?? 0;
      String lastActiveDateStr = data['lastActiveDate'] ?? '';

      // Get current date variables
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      if (lastActiveDateStr == todayStr) {
        // 1. Already updated today. Do nothing.
        return;
      } else if (lastActiveDateStr == yesterdayStr) {
        // 2. Continuous streak! Active yesterday and active today.
        currentStreak += 1;
      } else {
        // 3. User broke the streak (or it's a completely new user). Reset to 1.
        currentStreak = 1;
      }

      // Check if current streak beats their all-time high score
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      // Commit the updates to Firestore
      transaction.update(userDocRef, {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActiveDate': todayStr,
      });
    });
  }
}