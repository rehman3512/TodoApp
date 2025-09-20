import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final RxString selectedGender = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final User? user = auth.currentUser;

      if (user != null) {
        emailController.text = user.email ?? '';

        final DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          nameController.text = data['name'] ?? '';
          ageController.text = data['age']?.toString() ?? '';
          selectedGender.value = data['gender'] ?? '';
          profileImageUrl.value = data['profileImage'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  // Update profile
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;
      final User? user = auth.currentUser;

      if (user != null) {
        String imageUrl = profileImageUrl.value;

        // Upload new image if selected
        if (profileImage.value != null) {
          final Reference ref = storage
              .ref()
              .child('profile_images')
              .child('${user.uid}.jpg');

          await ref.putFile(profileImage.value!);
          imageUrl = await ref.getDownloadURL();
        }

        // Update user data in Firestore
        await firestore
            .collection('users')
            .doc(user.uid)
            .set({
          'name': nameController.text,
          'age': int.tryParse(ageController.text) ?? 0,
          'gender': selectedGender.value,
          'profileImage': imageUrl,
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    } finally {
      isUpdating.value = false;
    }
  }

  // Remove profile image and reset fields
  Future<void> removeProfile() async {
    try {
      final User? user = auth.currentUser;

      if (user != null) {
        // Delete profile image from storage if exists
        if (profileImageUrl.value.isNotEmpty) {
          final Reference ref = storage.refFromURL(profileImageUrl.value);
          await ref.delete();
        }

        // Clear profile data in Firestore
        await firestore
            .collection('users')
            .doc(user.uid)
            .update({
          'profileImage': FieldValue.delete(),
          'name': FieldValue.delete(),
          'age': FieldValue.delete(),
          'gender': FieldValue.delete(),
        });

        // Reset local values
        profileImage.value = null;
        profileImageUrl.value = '';
        nameController.clear();
        ageController.clear();
        selectedGender.value = '';

        Get.snackbar('Success', 'Profile removed successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove profile: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.onClose();
  }
}