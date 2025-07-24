import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/services/profile_s.dart';
import 'package:mobile/view/profile/profile.dart';

class UpdatePet extends StatefulWidget {
  final Map<String, dynamic> postData;
  const UpdatePet({super.key, required this.postData});

  @override
  State<UpdatePet> createState() => _UpdatePetState();
}

class _UpdatePetState extends State<UpdatePet> {
  late TextEditingController titleController;
  late TextEditingController petNameController;
  late TextEditingController petTypeController;
  late TextEditingController descriptionController;
  late bool isAdopted;
  bool isLoading = false;
  File? _imageFile;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.postData['title'] ?? '');
    petNameController = TextEditingController(text: widget.postData['petName'] ?? '');
    petTypeController = TextEditingController(text: widget.postData['petType'] ?? '');
    descriptionController = TextEditingController(text: widget.postData['description'] ?? '');
    isAdopted = widget.postData['isAdopted'] ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    petNameController.dispose();
    petTypeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      final bytes = await picked.readAsBytes();
      _imageBase64 = base64Encode(bytes);
    }
  }

  Future<void> _updatePet() async {
    setState(() {
      isLoading = true;
    });

    final updatedData = Map<String, dynamic>.from(widget.postData);
    updatedData['title'] = titleController.text;
    updatedData['petName'] = petNameController.text;
    updatedData['petType'] = petTypeController.text;
    updatedData['description'] = descriptionController.text;
    updatedData['isAdopted'] = isAdopted;
    updatedData['postTime'] = widget.postData['postTime'] ?? '';
    updatedData['postLatitude'] = widget.postData['postLatitude'] ?? '';
    updatedData['postLongitude'] = widget.postData['postLongitude'] ?? '';
    updatedData['imageUrl'] = widget.postData['imageUrl'] ?? '';
    updatedData['imageLocalPath'] = widget.postData['imageLocalPath'] ?? '';
    updatedData['userId'] = widget.postData['userId'] ?? '';
    updatedData['user'] = widget.postData['user'] ?? {};

    final success = await ProfileService.updatePost(
      updatedData,
      imageFile: _imageFile,
      imageBase64: _imageBase64,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Profile()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Güncelleme başarısız!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.postData['imageUrl'] ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        title: const Text("Peti Güncelle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Resim Seç"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Başlık"),
            ),
            TextFormField(
              controller: petNameController,
              decoration: const InputDecoration(labelText: "Pet Adı"),
            ),
            TextFormField(
              controller: petTypeController,
              decoration: const InputDecoration(labelText: "Pet Türü"),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Açıklama"),
            ),
            SwitchListTile(
              title: const Text("Sahiplendirildi mi?"),
              value: isAdopted,
              onChanged: (v) {
                setState(() {
                  isAdopted = v;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updatePet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Güncelle",
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
