import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';
import 'package:healthtrack/providers/activity_provider.dart';

class WaterProgressWidget extends StatefulWidget {
  final int current;
  final int target;
  final String date;
  final VoidCallback onStart;

  const WaterProgressWidget({
    super.key,
    required this.current,
    required this.target,
    required this.date,
    required this.onStart,
  });

  @override
  State<WaterProgressWidget> createState() => _WaterProgressWidgetState();
}

class _WaterProgressWidgetState extends State<WaterProgressWidget> {
  bool isSimulating = false;

  void _startSimulation() {
    if (widget.current >= widget.target || isSimulating) return;

    setState(() => isSimulating = true);

    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) { timer.cancel(); return; }
      final activity = context.read<ActivityProvider>();
      if (activity.water >= widget.target) {
        timer.cancel();
        setState(() => isSimulating = false);
      } else {
        activity.addWater(); // Nambah 1 otomatis
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    
    // Warna & UI
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
                  Text('${widget.target} gelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 20),
                  Text('Dibuat ${widget.date}', style: TextStyle(fontSize: 12, color: subTextColor)),
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
                children: List.generate(widget.target > 0 ? widget.target : 8, (index) {
                  final isFilled = index < widget.current;
                  return GestureDetector(
                    onTap: () {
                      if (!isFilled && !isSimulating) {
                        context.read<ActivityProvider>().addWater(); // MANUAL ADD
                      }
                    },
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: isFilled ? Colors.blueAccent : const Color(0xFF354052), shape: BoxShape.circle, border: !isFilled ? Border.all(color: Colors.white12) : null),
                      child: Icon(isFilled ? Icons.check : Icons.add, color: isFilled ? Colors.white : Colors.white24, size: 24),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text('Hari ini kamu sudah mencapai ${widget.current}/${widget.target} gelas.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: 120, height: 40,
                child: ElevatedButton(
                  onPressed: isSimulating ? null : _startSimulation, // LOGIC BARU
                  style: ElevatedButton.styleFrom(backgroundColor: btnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0), 
                  child: Text(isSimulating ? 'Minum...' : 'Mulai', style: const TextStyle(color: Colors.white))
                ),
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
  
  // Dummy Chart
  Widget _buildChartCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [const Text('7 hari terakhir', style: TextStyle(color: Colors.white, fontSize: 12)), const SizedBox(height: 24), SizedBox(height: 100, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (index) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 20, height: 20.0 + ((index * 10) % 50), decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(2))), const SizedBox(height: 8), Container(width: 10, height: 2, color: Colors.white24)]))))]),
    );
  }
}