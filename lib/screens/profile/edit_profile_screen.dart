import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'gallery_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    nameC = TextEditingController(text: user.name);
    emailC = TextEditingController(text: user.email);
    phoneC = TextEditingController(text: user.phone);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : Colors.white;
    final headerColor =
        isDark ? const Color(0xFF1B2B42) : const Color(0xFF1B2B42);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            height: 165,
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ubah Profil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ================= AVATAR =================
          Transform.translate(
            offset: const Offset(0, -50),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 60),
                ),

                /// PLUS ICON (PASTI BISA DIKLIK)
                Positioned(
                  bottom: 0,
                  right: -4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GalleryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B2B42),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= FORM =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _inputField('Nama', nameC, textColor),
                  const SizedBox(height: 12),
                  _inputField('Email', emailC, textColor),
                  const SizedBox(height: 12),
                  _inputField('No. telpon', phoneC, textColor),
                  const SizedBox(height: 40),

                  /// BUTTON
                  SizedBox(
                    width: 140,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2B42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        user.updateProfile(
                          name: nameC.text,
                          email: emailC.text,
                          phone: phoneC.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 132),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor.withOpacity(0.7))),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: const InputDecoration(
            isDense: true,
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
