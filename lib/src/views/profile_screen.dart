import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/viewmodels/profile/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<ProfileViewModel, ProfileState>(
        buildWhen: (prevState, current) =>
            current is ProfileDetailsLoading ||
            current is ProfileDetailsLoaded ||
            current is ProfileDetailsFailure,
        builder: (context, state) {
          if (state is ProfileDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileDetailsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                state.profileData.photoUrl!,
                              ),
                            ),

                             TextButton(
                              onPressed: () async {
                                final xPath = await _pickImage();

                                if (xPath != null) {
                                  if (context.mounted) {
                                    context.read<ProfileViewModel>().add(
                                      UpdateProfilePictureEvent(
                                        file: File(xPath.path),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.profileData.name!),
                          Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.profileData.email!),
                          Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.profileData.about!),
                          Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.profileData.phone ?? ""),
                          Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileDetailsFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    //  Picking image from gallery
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
