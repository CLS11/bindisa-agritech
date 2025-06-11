import 'package:agritech/models/profile_model.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {

  const SummaryScreen({required this.profile, super.key});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Crops Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Crops',
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.totalCrops.toString(),
                      style: const TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, 
                        vertical: 4,
                        ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        profile.latestBatch,
                        style: TextStyle(
                          color: Colors.green.shade800, 
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Latest Batch and Next Harvest
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.latestBatchDaysAgo,
                            style: TextStyle(
                              color: Colors.orange.shade800, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Last Harvest',
                            style: TextStyle(
                              fontSize: 12, 
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.pink.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nextHarvestDaysAway,
                            style: TextStyle(
                              color: Colors.pink.shade800, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Next Harvest',
                            style: TextStyle(
                              fontSize: 12, 
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Yield Performance
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yield Performance',
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${profile.yieldPerformanceValue}',
                                style: const TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: ' ${profile.yieldPerformanceUnit}',
                                style: const TextStyle(
                                  fontSize: 16, 
                                  color: Colors.grey,
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
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_upward, 
                                color: Colors.green.shade800, 
                                size: 16,
                              ),
                              Text(
                                '${profile.yieldPerformanceChange.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.green.shade800, 
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                ' ${profile.yieldPerformancePeriod}',
                                style: TextStyle(
                                  color: Colors.grey.shade600, 
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Wheat (Rabi 2023-24)',
                          style: TextStyle(
                            fontSize: 14, 
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${profile.wheatYield} t/acre',
                          style: const TextStyle(
                            fontSize: 14, 
                            color: Colors.black87, 
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Revenue & Earning Tracking
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revenue & Earning Tracking',
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Revenue (2023)',
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '₹${profile.totalRevenue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Average per crop',
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '₹${profile.averagePerCrop.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16, 
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'S&CG Growth',
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, 
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_upward, 
                                color: Colors.green.shade800, 
                                size: 16,
                              ),
                              Text(
                                '${profile.sCgGrowth.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.green.shade800, 
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
