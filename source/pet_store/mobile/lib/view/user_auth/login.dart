import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/services/login_s.dart';
import 'package:mobile/view_model/user_auth/login_vm.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      // Token varsa mainPage'e yönlendir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/mainPage');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F9),
      body: Column(
        children: [
          Container(
            height: 100,
            color: AppColors.yellow,
            padding: const EdgeInsets.only(top: 40, right: 16),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.person_add, color: AppColors.white),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register'); // yönlendirme
                  },
                  child: const Text(
                    "Üye Ol",
                    style: TextStyle(color:AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

          ),
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kullanıcı Adı",
                    style: TextStyle(
                        color: AppColors.yellow, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (v) => loginVM.username = v,
                  decoration: InputDecoration(
                    hintText: 'Kullanıcı adınızı giriniz',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey), // pasif durum
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.yellow, width: 2), // turuncu aktif kenar
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text("Şifre",
                    style: TextStyle(
                        color: AppColors.yellow, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  obscureText: true,
                  onChanged: (v) => loginVM.password = v,
                  decoration: InputDecoration(
                    hintText: 'Şifrenizi giriniz',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.yellow, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            final result = await LoginService.login(loginVM.username, loginVM.password);
                            final body = result['body'];
                            if (body['isSuccess'] == true && body['result'] != null) {
                              final token = body['result']['token'];
                              final user = body['result']['user'];
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('token', token);
                              await prefs.setString('user', jsonEncode(user));
                              // Konsola yazdır
                              print('TOKEN: $token');
                              print('USER: $user');
                              if (!mounted) return;
                              Navigator.pushReplacementNamed(context, '/mainPage');
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(body['message'] ?? 'Giriş başarısız')),
                              );
                            }
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:AppColors.yellow,
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
                            "Giriş Yap",
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
}
