import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';
import 'package:healthtrack/providers/activity_provider.dart';

class WorkoutProgressWidget extends StatefulWidget {
  final int current;
  final int target;
  final String type;
  final String time;
  final String date;
  final VoidCallback onStart;

  const WorkoutProgressWidget({
    super.key,
    required this.current,
    required this.target,
    required this.type,
    required this.time,
    required this.date,
    required this.onStart,
  });

  @override
  State<WorkoutProgressWidget> createState() => _WorkoutProgressWidgetState();
}

class _WorkoutProgressWidgetState extends State<WorkoutProgressWidget> {
  bool isSimulating = false;

  void _startSimulation() {
    if (widget.current >= widget.target || isSimulating) return;

    setState(() => isSimulating = true);

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) { timer.cancel(); return; }
      final activity = context.read<ActivityProvider>();
      if (activity.workout >= widget.target) {
        timer.cancel();
        setState(() => isSimulating = false);
      } else {
        activity.addWorkout(5); // NAMBAH 5 MENIT
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final topCardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    const statsCardColor = Color(0xFF18253A);
    const btnColor = Color(0xFF2B3648);
    final double percent = widget.target == 0 ? 0 : (widget.current / widget.target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Olahraga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
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
                  const SizedBox(height: 4),
                  Text(widget.type, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  const SizedBox(height: 8),
                  Text('${widget.target} menit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(widget.time, style: TextStyle(fontSize: 13, color: subTextColor)),
                  const SizedBox(height: 8),
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
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          decoration: BoxDecoration(color: statsCardColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(width: 140, height: 140, child: CircularProgressIndicator(value: percent, strokeWidth: 14, backgroundColor: const Color(0xFF2B3648), valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent), strokeCap: StrokeCap.round)),
                  Column(
                    children: [
                      const Text('On Track', style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${widget.target}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      Text('${widget.current}', style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text('Hari ini kamu sudah mencapai ${widget.current}/${widget.target} menit.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: 120, height: 40,
                child: ElevatedButton(
                  onPressed: isSimulating ? null : _startSimulation, // LOGIC BARU
                  style: ElevatedButton.styleFrom(backgroundColor: btnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0), 
                  child: Text(isSimulating ? 'Latihan...' : 'Mulai', style: const TextStyle(color: Colors.white))
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
      child: Column(children: [const Text('7 hari terakhir', style: TextStyle(color: Colors.white, fontSize: 12)), const SizedBox(height: 24), SizedBox(height: 100, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (index) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 20, height: 10.0 + ((index * 12) % 90), decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(2))), const SizedBox(height: 8), Container(width: 10, height: 2, color: Colors.white24)]))))]),
    );
  }
}