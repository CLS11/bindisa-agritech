/*
  The Profile class serves as an immutable data model, acting as a comprehensive 
  blueprint for all user profile information within the application.
  It consolidates diverse data points such as personal details (like fullName, e
  mailAddress, location), farming-specific metrics (e.g., acresInFarm, primaryCrops, 
  farmingExperienceYears), performance statistics (totalCrops, yieldPerformanceValue, 
  totalRevenue), and user preferences (notificationPreferencesEnabled, 
  profileVisibilityEnabled).
  All its fields are declared as final, ensuring that once a Profile object is 
  created with its constructor, which accepts required core details and applies 
  sensible default values for optional fields, its internal state cannot be 
  directly altered.
  This immutability is crucial for consistent state management, as any 
  modification to a user's profile necessitates the creation of a new Profile 
  instance; this is efficiently handled by the copyWith method, which allows 
  developers to produce a new object with specific updated values while inheriting 
  all other data from the original, thereby maintaining data integrity across the 
  application.

 */

class Profile {
  Profile({
    required this.fullName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.location,
    required this.memberSince,
    this.premiumMemberStatus = 'Premium Member',
    this.premiumMemberTagline = 'Connecting Agriculture, Empowering Farmers',
    // Farming Details
    this.acresInFarm = 5.2,
    this.farmingExperienceYears = 12,
    this.currentSeasonOverview = 'Kharif 2024 - 30 days ago',
    this.lastHarvest = 'Kharif 2024 - 30 days ago',
    this.nextPlanting = '2 weeks',
    this.primaryCrops = const ['Rice & Wheat'],
    this.equipmentAndTools = const [
      'Tractor - John Deere (300D)',
      'Irrigation System - Drip',
      'Harvester - Combine',
    ],
    // Statistics/Summary
    this.totalCrops = 24,
    this.latestBatch = 'Kharif 2024',
    this.latestBatchDaysAgo = '15 days ago',
    this.nextHarvestDaysAway = '2 weeks',
    this.yieldPerformanceValue = 4.2,
    this.yieldPerformanceUnit = 't/acre',
    this.yieldPerformanceChange = 4.2,
    this.yieldPerformancePeriod = '<1yr',
    this.wheatYield = 3.3,
    this.wheatYieldPeriod = '2023-24',
    this.riceYield = 4.2,
    this.riceAcres = 3.2,
    this.riceYieldChange = 12.0,
    this.totalRevenue = 87,
    this.averagePerCrop = 90,
    this.sCgGrowth = 15.2,
    // Settings
    this.notificationPreferencesEnabled = true,
    this.smsNotificationsEnabled = true,
    this.emailNotificationsEnabled = false,
    this.pushNotificationsEnabled = true,
    this.profileVisibilityEnabled = true,
  });
  final String fullName;
  final String mobileNumber;
  final String emailAddress;
  final String location;
  final String memberSince;
  final String premiumMemberStatus;
  final String premiumMemberTagline;

  // Farming Details
  final double acresInFarm;
  final int farmingExperienceYears;
  final String currentSeasonOverview;
  final String lastHarvest;
  final String nextPlanting;
  final List<String> primaryCrops;
  final List<String> equipmentAndTools;

  // Statistics/Summary
  final int totalCrops;
  final String latestBatch;
  final String latestBatchDaysAgo;
  final String nextHarvestDaysAway;
  final double yieldPerformanceValue;
  final String yieldPerformanceUnit;
  final double yieldPerformanceChange; // e.g., 4.2% up
  final String yieldPerformancePeriod; // e.g., <1yr
  final double riceYield;
  final double riceAcres;
  final double riceYieldChange;
  final double wheatYield;
  final String wheatYieldPeriod;
  final double totalRevenue;
  final double averagePerCrop;
  final double sCgGrowth; // S&CG growth

  // Settings
  final bool notificationPreferencesEnabled;
  final bool smsNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool profileVisibilityEnabled;

  Profile copyWith({
    String? fullName,
    String? mobileNumber,
    String? emailAddress,
    String? location,
    String? memberSince,
    String? premiumMemberStatus,
    String? premiumMemberTagline,
    double? acresInFarm,
    int? farmingExperienceYears,
    String? currentSeasonOverview,
    String? lastHarvest,
    String? nextPlanting,
    List<String>? primaryCrops,
    List<String>? equipmentAndTools,
    int? totalCrops,
    String? latestBatch,
    String? latestBatchDaysAgo,
    String? nextHarvestDaysAway,
    double? yieldPerformanceValue,
    String? yieldPerformanceUnit,
    double? yieldPerformanceChange,
    String? yieldPerformancePeriod,
    double? wheatYield,
    String? wheatYieldPeriod,
    double? riceYield,
    double? riceAcres,
    double? riceYieldChange,
    double? totalRevenue,
    double? averagePerCrop,
    double? sCgGrowth,
    bool? notificationPreferencesEnabled,
    bool? smsNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
    bool? profileVisibilityEnabled,
  }) {
    return Profile(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      location: location ?? this.location,
      memberSince: memberSince ?? this.memberSince,
      premiumMemberStatus: premiumMemberStatus ?? this.premiumMemberStatus,
      premiumMemberTagline: premiumMemberTagline ?? this.premiumMemberTagline,
      acresInFarm: acresInFarm ?? this.acresInFarm,
      farmingExperienceYears:
          farmingExperienceYears ?? this.farmingExperienceYears,
      currentSeasonOverview:
          currentSeasonOverview ?? this.currentSeasonOverview,
      lastHarvest: lastHarvest ?? this.lastHarvest,
      nextPlanting: nextPlanting ?? this.nextPlanting,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      equipmentAndTools: equipmentAndTools ?? this.equipmentAndTools,
      totalCrops: totalCrops ?? this.totalCrops,
      latestBatch: latestBatch ?? this.latestBatch,
      latestBatchDaysAgo: latestBatchDaysAgo ?? this.latestBatchDaysAgo,
      nextHarvestDaysAway: nextHarvestDaysAway ?? this.nextHarvestDaysAway,
      yieldPerformanceValue:
          yieldPerformanceValue ?? this.yieldPerformanceValue,
      yieldPerformanceUnit: yieldPerformanceUnit ?? this.yieldPerformanceUnit,
      yieldPerformanceChange:
          yieldPerformanceChange ?? this.yieldPerformanceChange,
      yieldPerformancePeriod:
          yieldPerformancePeriod ?? this.yieldPerformancePeriod,
      wheatYield: wheatYield ?? this.wheatYield,
      wheatYieldPeriod: wheatYieldPeriod ?? this.wheatYieldPeriod,
      riceYield: riceYield ?? this.riceYield,
      riceAcres: riceAcres ?? this.riceAcres,
      riceYieldChange: riceYieldChange ?? this.riceYieldChange,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      averagePerCrop: averagePerCrop ?? this.averagePerCrop,
      sCgGrowth: sCgGrowth ?? this.sCgGrowth,
      notificationPreferencesEnabled:
          notificationPreferencesEnabled ?? this.notificationPreferencesEnabled,
      smsNotificationsEnabled:
          smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      profileVisibilityEnabled:
          profileVisibilityEnabled ?? this.profileVisibilityEnabled,
    );
  }
}
