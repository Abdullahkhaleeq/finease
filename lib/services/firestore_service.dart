import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/saving_goal.dart';
import '../models/transaction.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  FirestoreService({required this.uid});

  // --------------- Transactions ---------------

  Stream<List<FinancialTransaction>> getTransactions() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FinancialTransaction.fromFirestore(doc)).toList());
  }

  Future<void> addTransaction(FinancialTransaction transaction) {
    return addTransactionSecurely(transaction);
  }

  Future<void> deleteTransaction(String id) {
    return _db.collection('users').doc(uid).collection('transactions').doc(id).delete();
  }

  // --------------- Saving Goals ---------------

  Stream<List<SavingGoal>> getSavingGoals() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('saving_goals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SavingGoal.fromFirestore(doc)).toList());
  }

  Future<void> addSavingGoal(SavingGoal goal) {
    return addSavingGoalSecurely(goal);
  }

  Future<void> updateSavingGoal(String goalId, Map<String, dynamic> data) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('saving_goals')
        .doc(goalId)
        .update(data);
  }

  Future<void> deleteSavingGoal(String goalId) {
    return _db.collection('users').doc(uid).collection('saving_goals').doc(goalId).delete();
  }

  Future<void> addContribution(String goalId, double amount) {
    return addContributionSecurely(goalId, amount);
  }

  Stream<List<Map<String, dynamic>>> getContributions(String goalId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('saving_goals')
        .doc(goalId)
        .collection('contributions')
        .orderBy('date', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'amount': (data['amount'] ?? 0).toDouble(),
                'date': (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
              };
            }).toList());
  }

  // --------------- Course Progress ---------------

  Future<void> saveCourseProgress(String courseId, int completedLessons, int totalLessons) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('course_progress')
        .doc(courseId)
        .set({
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>> getCourseProgress(String courseId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('course_progress')
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  Future<void> saveQuizScore(String courseId, String quizId, int score, int total) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('quiz_scores')
        .doc('${courseId}_$quizId')
        .set({
      'score': score,
      'total': total,
      'percentage': ((score / total) * 100).round(),
      'date': FieldValue.serverTimestamp(),
    });
  }

  // --------------- User Profile ---------------

  Future<void> saveUserProfile(Map<String, dynamic> data) async {
    final sanitized = _sanitizeData(data);
    await _db.collection('users').doc(uid).set(sanitized, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>> getUserProfile() {
    return _db.collection('users').doc(uid).snapshots().map((doc) => doc.data() ?? {});
  }

  // --------------- Security & Sanitization ---------------

  void _validateAmount(double amount) {
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
  }

  void _validateTitle(String title) {
    if (title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }
    if (title.length > 100) {
      throw Exception('Title is too long (max 100 chars)');
    }
  }

  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    // Remove any fields that shouldn't be updated directly by the user or are sensitive
    final protectedFields = ['uid', 'isAdmin', 'role', 'permissions', 'updatedAt', 'createdAt'];
    final sanitized = Map<String, dynamic>.from(data);
    
    for (var field in protectedFields) {
      sanitized.remove(field);
    }

    // Trim strings and ensure basic types
    sanitized.forEach((key, value) {
      if (value is String) {
        sanitized[key] = value.trim();
      }
    });

    return sanitized;
  }

  // Enhanced transaction addition with sanitization
  Future<void> addTransactionSecurely(FinancialTransaction transaction) {
    _validateAmount(transaction.amount);
    _validateTitle(transaction.title);

    final data = _sanitizeData(transaction.toMap());
    
    return _db.collection('users').doc(uid).collection('transactions').add({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
      'uid': uid, // Explicitly bind UID for rule matching if needed
    });
  }

  // Enhanced saving goal addition
  Future<void> addSavingGoalSecurely(SavingGoal goal) {
    _validateAmount(goal.targetAmount);
    _validateTitle(goal.title);

    final data = _sanitizeData(goal.toMap());
    
    return _db.collection('users').doc(uid).collection('saving_goals').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Enhanced contribution addition
  Future<void> addContributionSecurely(String goalId, double amount) async {
    _validateAmount(amount);

    final goalRef = _db.collection('users').doc(uid).collection('saving_goals').doc(goalId);
    final doc = await goalRef.get();
    
    if (!doc.exists) {
      throw Exception('Saving goal not found');
    }

    final current = (doc.data()?['currentAmount'] ?? 0.0).toDouble();
    final updated = current + amount;

    // Use a transaction for atomicity and security
    return _db.runTransaction((transaction) async {
      transaction.update(goalRef, {
        'currentAmount': updated,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final contribRef = goalRef.collection('contributions').doc();
      transaction.set(contribRef, {
        'amount': amount,
        'date': FieldValue.serverTimestamp(),
      });
    });
  }
}

