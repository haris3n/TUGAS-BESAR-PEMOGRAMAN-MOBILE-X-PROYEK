import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';

class WaterProgressWidget extends StatelessWidget {
  final int current;
  final int target;
  final String date; // Parameter Tanggal
  final VoidCallback onStart;

  const WaterProgressWidget({
    super.key,
    required this.current,
    required this.target,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Minum air', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
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
                  Text('$target gelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 20),
                  // TANGGAL DINAMIS
                  Text('Dibuat  $date', style: TextStyle(fontSize: 12, color: subTextColor)),
                ],
              ),
              Positioned(right: 0, top: 0, child: Icon(Icons.edit_outlined, size: 20, color: subTextColor))
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Statistik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
        const SizedBox(height: 12),
        // STATS CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
          decoration: BoxDecoration(color: statsCardColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Wrap(
                spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
                children: List.generate(target > 0 ? target : 8, (index) {
                  final isFilled = index < current;
                  return Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: isFilled ? Colors.blueAccent : const Color(0xFF354052), shape: BoxShape.circle),
                    child: Icon(isFilled ? Icons.check : Icons.add, color: isFilled ? Colors.white : Colors.white24, size: 24),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text('Hari ini kamu sudah mencapai $current/$target gelas.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: 120, height: 40,
                child: ElevatedButton(onPressed: onStart, style: ElevatedButton.styleFrom(backgroundColor: btnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0), child: const Text('Mulai', style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // CHART CARD
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
                final dummyHeights = [20.0, 45.0, 30.0, 60.0, 50.0, 75.0, 40.0];
                double height = dummyHeights[index % dummyHeights.length];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 20, height: height, decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(2))),
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