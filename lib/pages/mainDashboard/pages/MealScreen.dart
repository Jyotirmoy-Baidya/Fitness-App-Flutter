import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MealPlannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Nutrition Graph
            Text(
              'Meal Nutritions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black12, width: 1)),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 82),
                        FlSpot(1, 80),
                        FlSpot(2, 85),
                        FlSpot(3, 88),
                        FlSpot(4, 60),
                        FlSpot(5, 50),
                      ],
                      isCurved: true,
                      color: Colors.pink,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Weekly Button
                DropdownButton<String>(
                  value: 'Weekly',
                  items: ['Weekly', 'Daily']
                      .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                // Meal Schedule Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.pink),
                  child: Text('Check'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Today Meals Section
            Text(
              'Today Meals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                MealItem(
                    meal: 'Salmon Nigiri',
                    time: '7am',
                    icon: Icons.access_alarm),
                MealItem(
                    meal: 'Lowfat Milk', time: '8am', icon: Icons.local_drink),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final String meal;
  final String time;
  final IconData icon;

  const MealItem({
    required this.meal,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(meal),
        subtitle: Text('Today | $time'),
        trailing: Icon(Icons.notifications_none),
      ),
    );
  }
}
