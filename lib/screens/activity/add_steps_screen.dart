import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/theme_provider.dart';

class AddStepsScreen extends StatefulWidget {
  const AddStepsScreen({super.key});

  @override
  State<AddStepsScreen> createState() => _AddStepsScreenState();
}

class _AddStepsScreenState extends State<AddStepsScreen> {
  final TextEditingController stepsController = TextEditingController();
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
                    'Jumlah Langkah',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: stepsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: 5000',
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
                        border: Border.all(),
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
                      onPressed: () {
                        activity.addStepsActivity(
                          target: int.parse(stepsController.text),
                          period: selectedPeriod,
                          reminder: reminderTime,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Simpan'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            'Langkah kaki',
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
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
                    color: selected ? Colors.white : Colors.black,
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
