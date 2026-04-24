import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatPieChart extends StatefulWidget {
  final Map<String, int> data;
  final List<Color> colors;

  const StatPieChart({
    super.key,
    required this.data,
    required this.colors,
  });

  @override
  State<StatPieChart> createState() => _StatPieChartState();
}

class _StatPieChartState extends State<StatPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox.shrink();

    final entries = widget.data.entries.toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildSections(entries, total),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(entries.length, (i) {
                final color = widget.colors[i % widget.colors.length];
                final pct = total > 0 ? (entries[i].value / total * 100).toStringAsFixed(1) : '0';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('${entries[i].key} ($pct%)', style: Theme.of(context).textTheme.bodySmall),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(List<MapEntry<String, int>> entries, int total) {
    return List.generate(entries.length, (i) {
      final isTouched = i == _touchedIndex;
      final color = widget.colors[i % widget.colors.length];
      final value = entries[i].value.toDouble();

      return PieChartSectionData(
        value: value,
        color: color,
        radius: isTouched ? 65 : 55,
        title: isTouched ? '${entries[i].value}' : '',
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      );
    });
  }
}
