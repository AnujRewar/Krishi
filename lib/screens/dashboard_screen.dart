import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWeatherCard(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildAlertsSection(),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Weather', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Sunny, 28°C', style: TextStyle(color: Colors.grey[600])),
                  Text('Humidity: 65%', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildActionCard('Crop Prediction', Icons.analytics),
            _buildActionCard('Get Advice', Icons.lightbulb),
            _buildActionCard('Pest Control', Icons.bug_report),
            _buildActionCard('Irrigation', Icons.water_drop),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAlertItem('Irrigation needed for Wheat field', Icons.warning, Colors.orange),
                const Divider(),
                _buildAlertItem('Fertilizer time in 3 days', Icons.info, Colors.blue),
                const Divider(),
                _buildAlertItem('Pest alert in nearby farms', Icons.bug_report, Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
        const Icon(Icons.chevron_right, size: 16),
      ],
    );
  }
}