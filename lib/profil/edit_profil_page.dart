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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  bool _isLoading = true;

  final ProfilController _profilController = ProfilController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final data = await _profilController.fetchProfileData(context);
      setState(() {
        _formData = data;
        _isLoading = false;
      });
    } catch (e) {
      Navigator.pop(context); // Kembali jika ada error
    }
  }

  Future<void> _onSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _profilController.saveProfile(context, _formData);
      GoRouter.of(context).go('/profil');
    } catch (e) {
      // Error sudah ditangani di ProfilController
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? const Navbar()
          : AppBar(
              title: const Text(
                'Edit Profil',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Perbarui informasi pribadi Anda",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ..._formData.keys.map((field) {
                            if (field == 'hidden_fields' ||
                                field == 'stambuk') {
                              return Container();
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                initialValue:
                                    _formData[field]?.toString() ?? '',
                                decoration: InputDecoration(
                                  labelText:
                                      field.replaceAll('_', ' ').toUpperCase(),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _formData[field] = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onSaveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Simpan Perubahan',
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
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF2C7566),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: const Center(
                      child: Text(
                        "© 2025 IKPM Sidoarjo. All Rights Reserved.",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
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
