import 'package:agritech/models/profile_model.dart';
import 'package:flutter/material.dart';

/*
  The SummaryScreen file defines the user interface for the "Statistics" tab 
  within the user profile, providing a visual overview of key farming 
  performance and financial data. 
  This StatelessWidget dynamically displays information fetched from the 
  Profile model, including total crops, recent harvest details, and upcoming 
  planting schedules. 
  It meticulously presents yield performance with numerical values, units, 
  and percentage changes, along with specific crop yields like wheat, all 
  within clearly structured Card widgets and RichText for combined styling.
  Additionally, the screen includes a dedicated section for "Revenue & Earning 
  Tracking," detailing total revenue, average per crop earnings, and sales & 
  customer growth, employing Dividers for visual separation, thereby offering 
  a comprehensive and organized statistical summary of the user's agricultural 
  activities. 
 */

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({required this.profile, super.key});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Total Crops
          _statCard(
            title: 'Total Crops',
            emoji: '🌾',
            value: '${profile.totalCrops}',
            subtitle: 'This year',
            background: Colors.blue.shade50,
          ),
          const SizedBox(height: 12),

          /// Active Season
          _statCard(
            title: 'Active Season',
            emoji: '🚜',
            value: 'Kharif 2024',
            subtitle: 'Current',
            background: Colors.green.shade50,
          ),
          const SizedBox(height: 12),

          /// Last Harvest
          _statCard(
            title: 'Last Harvest',
            emoji: '📦',
            value: profile.latestBatchDaysAgo,
            subtitle: 'Completed',
            background: Colors.yellow.shade100,
          ),
          const SizedBox(height: 12),

          /// Next Planting
          _statCard(
            title: 'Next Planting',
            emoji: '⏰',
            value: profile.nextHarvestDaysAway,
            subtitle: 'Scheduled',
            background: Colors.pink.shade100,
          ),
          const SizedBox(height: 16),

          /// Yield Performance Section
          _yieldPerformanceSection(profile),

          const SizedBox(height: 16),

          /// Revenue Tracking Section
          _revenueTrackingSection(profile),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String emoji,
    required String value,
    required String subtitle,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            emoji, 
            style: const TextStyle(
              fontSize: 24,
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
                        fontSize: 13, 
                        color: Colors.grey, 
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                const SizedBox(height: 4),
                Text(
                  value,
                    style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black,
                      ),
                    ),
                Text(
                  subtitle,
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _yieldPerformanceSection(Profile profile) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Yield Performance',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 12),

            /// Rice
            _yieldRow(
                crop: 'Rice (Kharif 2024)',
                yieldValue: '${profile.riceYield.toStringAsFixed(1)} tons',
                acres: '${profile.riceAcres.toStringAsFixed(1)} acres',
                change: '${profile.riceYieldChange >= 0 ? '+' : ''}${
                  profile.riceYieldChange.toStringAsFixed(1)}% vs last year',
                isNegative: profile.riceYieldChange < 0,
            ),

            const SizedBox(height: 12),

            /// Wheat
            _yieldRow(
              crop: 'Wheat (Rabi 2023-24)',
              yieldValue: '${profile.wheatYield} tons',
              acres: '2.0 acres',
              change: '-8% vs last year',
              isNegative: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _yieldRow({
    required String crop,
    required String yieldValue,
    required String acres,
    required String change,
    bool isNegative = false,
  }) {
    final color = isNegative ? Colors.red : Colors.green;
    final icon = isNegative ? Icons.arrow_downward : Icons.arrow_upward;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          crop,
            style: const TextStyle(
                fontWeight: FontWeight.w500, 
                fontSize: 14, 
                color: Colors.black87,
              ),
            ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              acres,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            Row(
              children: [
                Text(
                  yieldValue,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                const SizedBox(width: 6),
                Icon(
                  icon, 
                  size: 16, 
                  color: color,
                ),
                Text(
                  change,
                    style: TextStyle(
                      fontSize: 12, 
                      color: color,
                    ),
                  ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _revenueTrackingSection(Profile profile) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💰 Revenue Tracking',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 12),
            _revenueRow(
              'Total Revenue (2024)',
              '₹${profile.totalRevenue.toStringAsFixed(0)}',
              bold: true, 
              color: Colors.green.shade700,
            ),
            const Divider(),
            _revenueRow(
              'Average per acre',
              '₹${profile.averagePerCrop.toStringAsFixed(0)}',
            ),
            const Divider(),
            _revenueRow('Growth vs 2023',
                '+${profile.sCgGrowth.toStringAsFixed(1)}%',
                icon: Icons.arrow_upward,
                iconColor: Colors.green.shade700,
              ),
          ],
        ),
      ),
    );
  }

  Widget _revenueRow(String title, String value,
      {bool bold = false, IconData? icon, Color? iconColor, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
              const TextStyle(
                fontSize: 14, 
                color: Colors.black87,
                ),
              ),
        Row(
          children: [
            if (icon != null)
              Icon(
                icon, 
                size: 16, 
                color: iconColor ?? Colors.black54,
              ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: iconColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
