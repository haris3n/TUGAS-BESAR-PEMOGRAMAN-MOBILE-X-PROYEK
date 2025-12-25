import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';

class StepsProgressWidget extends StatelessWidget {
  final int current;
  final int target;
  final String time;
  final String date; // Parameter Tanggal
  final VoidCallback onStart;

  const StepsProgressWidget({
    super.key,
    required this.current,
    required this.target,
    required this.time,
    required this.date, // Wajib
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    
    final topCardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    const statsCardColor = Color(0xFF18253A); 
    const btnColor = Color(0xFF2B3648);

    final double percent = target == 0 ? 0 : (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Langkah kaki', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
        const SizedBox(height: 12),
        // TOP CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: topCardColor, borderRadius: BorderRadius.circular(20), boxShadow: [if (!isDark) BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('24 jam', style: TextStyle(fontSize: 13, color: subTextColor)),
                  const SizedBox(height: 8),
                  Text('$target', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(time, style: TextStyle(fontSize: 13, color: subTextColor)),
                  const SizedBox(height: 8),
                  // TANGGAL DINAMIS
                  Text('Dibuat  $date', style: TextStyle(fontSize: 12, color: subTextColor)),
                ],
              ),
              Positioned(right: 0, top: 0, child: Icon(Icons.edit_outlined, size: 20, color: subTextColor))
            ],
          ),
        ),
        // ... (Bagian bawah sama persis, copy dari file sebelumnya atau biarkan jika sudah benar)
        const SizedBox(height: 24),
        Text('Statistik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          decoration: BoxDecoration(color: statsCardColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140, height: 140,
                    child: CircularProgressIndicator(value: percent, strokeWidth: 14, backgroundColor: const Color(0xFF2B3648), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)), strokeCap: StrokeCap.round),
                  ),
                  Column(
                    children: [
                      const Text('On Track', style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('$target', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      Text('$current', style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text('Hari ini kamu sudah mencapai $current/$target langkah.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: 120, height: 40,
                child: ElevatedButton(onPressed: onStart, style: ElevatedButton.styleFrom(backgroundColor: btnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0), child: const Text('Mulai', style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildChartCard(statsCardColor),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildChartCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text('7 hari terakhir', style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                double height = 10.0 + ((index * 12) % 90); 
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 20, height: height, decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 8),
                    Container(width: 10, height: 2, color: Colors.white24)
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}