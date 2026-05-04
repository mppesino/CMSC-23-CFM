import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_transactions_api.dart';
import '../models/transaction.dart';

class TransactionsProvider with ChangeNotifier{

  late Stream<QuerySnapshot> _transactionsStream;
  final FirebaseTransactionsApi firebaseService = FirebaseTransactionsApi();

  TransactionsProvider(){
    fetchTransactions();
  }

  Stream<QuerySnapshot> get transaction => _transactionsStream;

  void fetchTransactions(){
    _transactionsStream = firebaseService.getAllTransactions();
    notifyListeners();
  }

    Future<PostTransaction?> getTransactionById(String id) async {
    try {
      DocumentSnapshot doc = await firebaseService.getTransaction(id);
      
      if (doc.exists) {
        return PostTransaction.fromJson(doc.data() as Map<String, dynamic>..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      print("Error getting transaction: $e");
      return null;
    }
  }

  Future<void> addTransaction(PostTransaction transaction, String giverId, String postId) async {
    String message = await firebaseService.addTransaction(transaction.toJson(), giverId, postId);
    print(message);
    notifyListeners();
  }

  Future<void> updateTransactionReceiverId(String id, String receiverId) async {
    String message = await firebaseService.updateTransactionReceiver(id, receiverId);
    print(message);
    notifyListeners();
  }

  Future<void> updateTransactionStatus(String id, TransactionStatus status) async {
    String message = await firebaseService.updateTransactionStatus(id, status);
    print(message);
    notifyListeners();
  }


  Future<void> deleteTransaction(String id) async {
    String message = await firebaseService.deleteTransaction(id);
    print(message);
    notifyListeners();
  }



}