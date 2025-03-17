import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_application_1/features/authentication/models/user.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to save user data to firestore.
  Future<void> saveUserRecord(User user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      Loaders.errorSnackBar(title: e.message);
      rethrow;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'Something went wrong.');
      rethrow;
    }
  }

  // Function to fetch user details based on user ID.
  Future<User?> fetchUserDetails() async {
    try {
      final docSnapshot = await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      if (docSnapshot.exists) {
        return User.fromSnapshot(docSnapshot); // Return the user data
      } else {
        return User.empty(); // Return an empty user if not found
      }
    } on FirebaseException catch (_) {
      Loaders.errorSnackBar(title: 'Error', message: 'User not found.');
      return null; // Return null on Firebase exception
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'Something went wrong.');
      rethrow; // Rethrow on general errors
    }
  }

  // Function to update user data in Firestore.
  Future<void> updateUserDetails(User updatedUser) async {
    try {
      await _db
          .collection('Users')
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseException catch (_) {
      Loaders.errorSnackBar(title: 'Error', message: 'User not found.');
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'Something went wrong.');
      rethrow; // Rethrow on general errors
    }
  }

  // Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (_) {
      Loaders.errorSnackBar(title: 'Error', message: 'User not found.');
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'Something went wrong.');
      rethrow; // Rethrow on general errors
    }
  }

  // Remove user data from firestore
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection('Users').doc(userId).delete();
    } on FirebaseException catch (_) {
      Loaders.errorSnackBar(title: 'Error', message: 'User not found.');
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'Something went wrong.');
      rethrow; // Rethrow on general errors
    }
  }
}
