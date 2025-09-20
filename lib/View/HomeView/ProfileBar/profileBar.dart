import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/Controller/profilecontroller.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';

class ProfileBar extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : GradiantColor(
            child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              // Profile Picture
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: ClipOval(
                      child: controller.profileImage.value != null
                          ? Image.file(
                        controller.profileImage.value!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                          : controller.profileImageUrl.value.isNotEmpty
                          ? Image.network(
                        controller.profileImageUrl.value,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 80, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () => _showImagePickerOptions(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // User Info Form
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      style: TextStyle(color: AppColors.whiteColor),
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.whiteColor),
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email Field (Read-only)
                    TextFormField(
                      style: TextStyle(color: AppColors.whiteColor),
                      controller: controller.emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.whiteColor),
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Age Field
                    TextFormField(
                      style: TextStyle(color: AppColors.whiteColor),
                      controller: controller.ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.whiteColor),
                        labelText: 'Age',
                        prefixIcon: const Icon(Icons.cake,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final age = int.tryParse(value);
                          if (age == null || age < 1 || age > 150) {
                            return 'Please enter a valid age';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: controller.selectedGender.value.isEmpty
                          ? null
                          : controller.selectedGender.value,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.whiteColor),
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.person_outline,color: Colors.white,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        controller.selectedGender.value = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.updateProfile(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isUpdating.value
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Remove Profile Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => controller.removeProfile(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text(
                          'Remove Profile',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
                    ),
                  ),
          ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}