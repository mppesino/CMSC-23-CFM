import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_sharing/models/transaction.dart';

class FirebasePostsApi {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllPosts() {
    return db.collection('posts').snapshots(); 
  }

  Stream<QuerySnapshot> getPostsByUser(String? uid) {
    return db.collection('posts').where('userId', isEqualTo: uid).snapshots(); 
  }

  Future<DocumentSnapshot> getPost(String id) async {
    return await db.collection('posts').doc(id).get();
  }

  Future<String> addPost(Map<String, dynamic> post, String? uid) async{

    try{
      DocumentReference docRef = db.collection('posts').doc();
      post['id'] = docRef.id;
      post['userId'] = uid; 

      await docRef.set(post);
      
      return "Successfully added post!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> deletePost(String id) async{
    try{
      await db.collection('posts').doc(id).delete();
      return "Successfully deleted post!";
    }on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> editPost(String id, Map<String, dynamic> post) async{

    try {
      await db.collection('posts').doc(id).update({'title': post['title'], 'description': post['description'], 'tags':post['tags'], 'expiration':post['expiration']} );
      return "Successfully edited expense!";
    } 
     on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
  }

Future<String> updatePostStatus(String id, TransactionStatus status) async {
  try {
    await db.collection('posts').doc(id).update({
      'status': status.name,
    });

    return "Successfully updated post status!";
  } on FirebaseException catch (e) {
    return "Error on ${e.code}: ${e.message}";
  }
}

}
