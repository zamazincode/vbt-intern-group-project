import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/services/add_pet_s.dart';
import 'package:mobile/view/profile/profile.dart';
import 'package:mobile/view_model/add_pet/add_pet_vm.dart';
import 'package:provider/provider.dart';

class AddPet extends StatelessWidget {
  const AddPet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddPetViewModel(),
      child: const AddPetForm(),
    );
  }
}

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddPetViewModel>(context, listen: false).setUserFromPrefs();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(AddPetViewModel vm) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        vm.imageLocalPath = picked.path;
      });
      final bytes = await picked.readAsBytes();
      vm.imageBase64 = base64Encode(bytes);
    }
  }

  Future<void> _pickDate(BuildContext context, AddPetViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (time != null) {
        final dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        setState(() {
          vm.postTime = dateTime;
          _dateController.text = dateTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddPetViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        leading: BackButton(),
        title: const Text("Pet Ekle"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Başlık"),
                onChanged: (v) => vm.title = v,
                validator: (v) => v == null || v.isEmpty ? "Başlık giriniz" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Pet Adı"),
                onChanged: (v) => vm.petName = v,
                validator: (v) => v == null || v.isEmpty ? "Pet adı giriniz" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Pet Türü"),
                onChanged: (v) => vm.petType = v,
                validator: (v) => v == null || v.isEmpty ? "Pet türü giriniz" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Açıklama"),
                onChanged: (v) => vm.description = v,
                validator: (v) => v == null || v.isEmpty ? "Açıklama giriniz" : null,
              ),
              SwitchListTile(
                title: const Text("Sahiplendirildi mi?"),
                value: vm.isAdopted,
                onChanged: (v) {
                  vm.isAdopted = v;
                  vm.notifyListeners(); // <-- Bunu ekle
                  setState(() {}); // <-- İsteğe bağlı, ama notifyListeners yeterli
                },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Paylaşım Tarihi"),
                onTap: () => _pickDate(context, vm),
                validator: (v) => vm.postTime == null ? "Tarih seçiniz" : null,
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(vm),
                    icon: const Icon(Icons.image),
                    label: const Text("Resim Seç"),
                  ),
                  const SizedBox(width: 12),
                  _imageFile != null
                      ? Image.file(_imageFile!, width: 60, height: 60, fit: BoxFit.cover)
                      : const Text("Resim seçilmedi"),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_imageFile == null && (vm.imageBase64 == null || vm.imageBase64!.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Lütfen bir resim seçin.")),
                            );
                            return;
                          }
                          vm.setLoading(true);
                          final response = await AddPetService.createPost(vm.toRequestBody(), imageFile: _imageFile);
                          vm.setLoading(false);
                          if (response.statusCode == 200 || response.statusCode == 201) {
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const Profile()),
                                  (route) => false,
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.body)),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: vm.isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      strokeWidth: 3,
                    ),
                  )
                      : const Text(
                    "Kaydet",
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
