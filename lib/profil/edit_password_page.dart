import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ikpm_sidoarjo/controllers/profil_controller.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../layouts/navbar_layout.dart';
import '../layouts/bottom_bar.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key}) : super(key: key);

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  String _confirmPassword = '';

  final ProfilController _profilController = ProfilController();

  Future<void> _onSavePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _profilController.savePassword(context, _newPassword);
      GoRouter.of(context).go('/profil'); // Redirect ke halaman profil
    } catch (e) {
      // Error sudah ditangani di ProfilController
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? const Navbar() // Navbar untuk Web
          : AppBar(
              title: const Text(
                'Edit Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, // Ukuran font lebih besar
                  fontWeight:
                      FontWeight.w600, // Berat font medium untuk kesan elegan
                  fontFamily: 'Roboto', // Gunakan font elegan, contoh: Roboto
                  letterSpacing: 1.2, // Memberikan spasi antar huruf
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 23, 114, 110),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  GoRouter.of(context).go('/profil');
                },
              ),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) => _newPassword = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password baru harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) => _confirmPassword = value,
                  validator: (value) {
                    if (value != _newPassword) {
                      return 'Konfirmasi password tidak sesuai';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSavePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Simpan Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: kIsWeb
          ? null
          : BottomBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  GoRouter.of(context).go('/profil');
                } else if (index == 1) {
                  GoRouter.of(context).go('/alumni');
                }
              },
            ),
    );
  }
}
