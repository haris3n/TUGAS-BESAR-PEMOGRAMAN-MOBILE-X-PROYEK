import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/theme_provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  TimeOfDay reminderTime = TimeOfDay.now();
  int selectedPeriod = 0; // 0=24 jam, 1=7 hari, 2=30 hari

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final activity = context.read<ActivityProvider>();
    final isDark = theme.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _header(context, isDark),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _periodSelector(isDark),
                    const SizedBox(height: 20),
                    Text(
                      'Jenis Olahraga',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        hintText: 'Pilih olahraga',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Durasi (menit)',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '30',
                        suffixText: 'menit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Jam Pengingat',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: reminderTime,
                        );
                        if (picked != null) {
                          setState(() => reminderTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          reminderTime.format(context),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // LOGIC DATABASE: Validasi input agar tidak crash saat parse
                          if (typeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Isi jenis olahraga')),
                            );
                            return;
                          }

                          // Simpan ke Provider (yang terhubung ke Database)
                          await activity.addWorkoutActivity(
                            type: typeController.text,
                            duration:
                                int.tryParse(durationController.text) ?? 0,
                            period: selectedPeriod,
                            reminder: reminderTime,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER & SELECTOR (TIDAK BERUBAH) =================
  Widget _header(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF183B5B) : Colors.blue.shade100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Olahraga',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _periodSelector(bool isDark) {
    final labels = ['24 jam', '7 hari', '30 hari'];
    return Row(
      children: List.generate(3, (i) {
        final selected = selectedPeriod == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedPeriod = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue
                    : (isDark ? Colors.black26 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
