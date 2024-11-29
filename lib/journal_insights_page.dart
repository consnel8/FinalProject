import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'journal_entry_model.dart';

class JournalInsightsPage extends StatelessWidget {
  final List<JournalEntry> entries;

  const JournalInsightsPage({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate mood frequencies and insights
    Map<String, int> moodFrequency = _calculateMoodFrequency(entries);
    var totalEntries = entries.isNotEmpty ? entries.length : 1;

    // Calculate mood percentages
    Map<String, double> moodPercentages = _calculateMoodPercentages(moodFrequency, totalEntries);

    // Sort moods by frequency
    var sortedMoods = moodFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Prepare data for the charts
    List<BarChartGroupData> barChartData = _prepareBarChartData(sortedMoods);
    List<FlSpot> lineChartData = _prepareLineChartData(sortedMoods);

    // Peak mood and personalized message
    String peakMood = sortedMoods.isNotEmpty ? sortedMoods.first.key : 'No data';
    int peakMoodCount = sortedMoods.isNotEmpty ? sortedMoods.first.value : 0;
    String personalizedMessage = _getPersonalizedMessage(peakMood);

    // Detect dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mood Trends',
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 38,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mood Trends Over Time',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Line Chart
              AspectRatio(
                aspectRatio: 1.9,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: lineChartData,
                        isCurved: true,
                        color: Colors.blue,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [Colors.blue.withOpacity(0.4), Colors.blue.withOpacity(0.1)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < sortedMoods.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    sortedMoods[index].key,
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Remove left axis titles
                      ),
                    ),
                    borderData: FlBorderData(show: true, border: Border.all(color: isDarkMode ? Colors.white : Colors.black12)),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mood Breakdown
              Text(
                'Mood Breakdown (in %):',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              if (moodPercentages.isNotEmpty)
                ...moodPercentages.entries.map((mood) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${mood.key}: ${mood.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              const SizedBox(height: 20),

              // Peak Mood
              Text(
                'Peak Mood:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '$peakMood (Count: $peakMoodCount)',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Personalized Message
              Text(
                personalizedMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Bar Chart
              Text(
                'Mood Frequency Distribution:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < sortedMoods.length) {
                              return Transform.rotate(
                                angle: -0.5,
                                child: Text(
                                  sortedMoods[index].key,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Remove left axis titles
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                    barGroups: barChartData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Calculate mood frequency from journal entries
  Map<String, int> _calculateMoodFrequency(List<JournalEntry> entries) {
    Map<String, int> moodFrequency = {};

    for (var entry in entries) {
      if (entry.mood != null) {
        moodFrequency[entry.mood!] = (moodFrequency[entry.mood!] ?? 0) + 1;
      }
    }

    return moodFrequency;
  }

  // Calculate the percentage of each mood based on the total number of entries
  Map<String, double> _calculateMoodPercentages(Map<String, int> moodFrequency, int totalEntries) {
    Map<String, double> moodPercentages = {};

    moodFrequency.forEach((mood, count) {
      moodPercentages[mood] = (count / totalEntries) * 100;
    });

    return moodPercentages;
  }

  // Prepare the data for the bar chart based on mood frequencies
  List<BarChartGroupData> _prepareBarChartData(List<MapEntry<String, int>> sortedMoods) {
    List<BarChartGroupData> data = [];
    for (int i = 0; i < sortedMoods.length; i++) {
      final mood = sortedMoods[i].key;
      final count = sortedMoods[i].value;

      data.add(BarChartGroupData(
        x: i, // Position on the x-axis (mood index)
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: _getMoodColor(mood),
            borderRadius: BorderRadius.circular(6), // Smooth rounded corners
          )
        ],
      ));
    }
    return data;
  }

  // Prepare the data for the line chart
  List<FlSpot> _prepareLineChartData(List<MapEntry<String, int>> sortedMoods) {
    List<FlSpot> data = [];
    for (int i = 0; i < sortedMoods.length; i++) {
      final count = sortedMoods[i].value;
      data.add(FlSpot(i.toDouble(), count.toDouble())); // Mood frequency as y-value
    }
    return data;
  }

  // Get mood color based on the mood
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy 😊':
        return const Color(0xFFFFD700); // Soft yellow
      case 'sad 🌧️':
        return const Color(0xFF87CEEB); // Soft blue
      case 'motivated 🎯':
        return const Color(0xFF98FB98); // Pale green
      case 'excited 🎉':
        return const Color(0xFFFFA07A); // Light coral
      case 'relaxed 🧘':
        return const Color(0xFFBA55D3); // Orchid
      case 'grateful 🙏':
        return const Color(0xFF40E0D0); // Turquoise
      case 'stressed 😓':
        return const Color(0xFFFF69B4); // Hot pink
      default:
        return const Color(0xFFC0C0C0); // Light gray
    }
  }



  // Personalized message based on the peak mood
  String _getPersonalizedMessage(String peakMood) {
    switch (peakMood.toLowerCase()) {
      case 'happy 😊':
        return 'Keep spreading that joy! Your positivity is contagious!';
      case 'motivated 🎯':
        return 'Great job! Keep pushing forward with that motivation!';
      case 'excited 🎉':
        return 'Your excitement is fueling your progress! Keep it up!';
      case 'sad 🌧️':
        return 'It’s okay to feel down sometimes. Take care of yourself and reach out if you need support.';
      case 'relaxed 🧘':
        return 'Enjoy the peace and calm you’ve found. Take this time to recharge!';
      case 'grateful 🙏':
        return 'Gratitude is a powerful force. Keep appreciating the little things!';
      default:
        return 'Keep going! Every mood is part of your unique journey!';
    }
  }
}
