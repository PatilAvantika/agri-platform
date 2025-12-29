import 'package:flutter/material.dart';

class DroneScreen extends StatelessWidget {
  const DroneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Text(
                    "Agri Drone Control",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF5E35B1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.flight,
                      color: Colors.white,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Drone Status: Active",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Battery: 85%",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildControlCard(
                icon: Icons.play_arrow,
                title: "Start Mission",
                subtitle: "Begin automated field scanning",
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              _buildControlCard(
                icon: Icons.stop,
                title: "Stop Mission",
                subtitle: "Stop current drone operation",
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              _buildControlCard(
                icon: Icons.map,
                title: "Flight Map",
                subtitle: "View current flight path",
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              _buildControlCard(
                icon: Icons.camera_alt,
                title: "Camera View",
                subtitle: "Live drone camera feed",
                color: Colors.orange,
              ),
              const SizedBox(height: 30),
              const Text(
                "Recent Missions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildMissionCard(
                title: "North Field Scan",
                date: "Today, 2:30 PM",
                status: "Completed",
                statusColor: Colors.green,
              ),
              const SizedBox(height: 10),
              _buildMissionCard(
                title: "Irrigation Check",
                date: "Yesterday, 10:15 AM",
                status: "Completed",
                statusColor: Colors.green,
              ),
              const SizedBox(height: 10),
              _buildMissionCard(
                title: "Pest Detection",
                date: "Dec 25, 4:45 PM",
                status: "Completed",
                statusColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard({
    required String title,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.flight,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
