import 'package:flutter/material.dart';
import 'package:pet_store/constants/colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.white,
      body: Column(
        children: [
          Container(
            height: 100,
            color:AppColors.yellow,
            padding: const EdgeInsets.only(top: 40, left: 16),
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // 🔙 Geri dönüş
              },
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, color: AppColors.white),
                  SizedBox(width: 8),
                  Text("Geri", style: TextStyle(color: AppColors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildField("Ad", "Adınızı girin"),
                buildField("Soyad", "Soyadınızı girin"),
                buildField("Kullanıcı Adı", "Kullanıcı adınızı girin"),
                buildField("E-posta", "E-posta adresinizi girin", keyboardType: TextInputType.emailAddress),
                buildField("Şifre", "Şifre belirleyin", isPassword: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Register işlemleri burada yapılacak
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:AppColors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String label, String hint,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(label,
            style: const TextStyle(color:AppColors.yellow, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color:AppColors.yellow, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}
