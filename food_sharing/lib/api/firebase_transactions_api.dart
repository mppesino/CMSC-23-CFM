import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_sharing/models/transaction.dart';

class FirebaseTransactionsApi {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllTransactions() {
    return db.collection('transactions').snapshots(); 
  }

  Stream<QuerySnapshot> getTransactionsByGiver(String? uid) {
    return db.collection('transactions').where('giverId', isEqualTo: uid).snapshots(); 
  }

  Future<DocumentSnapshot> getTransaction(String id) async {
    return await db.collection('transactions').doc(id).get();
  }

  Future<String> addTransaction(Map<String, dynamic> transaction, String giverId, String postId) async{

    try{
      DocumentReference docRef = db.collection('transactions').doc();
      transaction['id'] = docRef.id;
      transaction['giverId'] = giverId; 
      transaction['postId'] = postId; 
      transaction['createdAt'] = FieldValue.serverTimestamp(); 

      await docRef.set(transaction);
      
      return "Successfully added transaction!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> deleteTransaction(String id) async{
    try{
      await db.collection('transactions').doc(id).delete();
      return "Successfully deleted transaction!";
    }on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> updateTransactionReceiver(String id, String receiverId) async{

    try {
      await db.collection('transactions').doc(id).update({'receiverId': receiverId} );
      return "Successfully edited transaction receiver!";
    } 
     on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

Future<String> updateTransactionStatus(String id, TransactionStatus status) async {
  try {
    await db.collection('transactions').doc(id).update({
      'status': status.name,
    });

    return "Successfully updated transaction status!";
  } on FirebaseException catch (e) {
    return "Error on ${e.code}: ${e.message}";
  }
}

}
