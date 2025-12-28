import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../services/farm_info_service.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../../shared/widgets/agri_card.dart';
import '../../shared/widgets/agri_trust_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  UserProfile? _currentProfile;
  bool _isLoading = true;
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ProfileService.getUserProfile();
      
      // Calculate trust score if not already set
      int calculatedTrustScore = FarmInfoService.calculateTrustScore(profile);
      
      setState(() {
        _currentProfile = profile.copyWith(trustScore: calculatedTrustScore);
        _isLoading = false;
      });
      
      _animationController.forward();
    } catch (e) {
      setState(() {
        _currentProfile = UserProfile.defaultProfile();
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  Future<void> _refreshProfile() async {
    setState(() => _isRefreshing = true);
    await _loadProfile();
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile & Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
              onPressed: _refreshProfile,
              tooltip: 'Refresh Profile',
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _refreshProfile,
                color: const Color(0xFF2E7D32),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _profileHeader(),
                      const SizedBox(height: 16),
                      _carbonProfileCard(),
                      const SizedBox(height: 16),
                      _farmDetailsCard(),
                      const SizedBox(height: 16),
                      _verificationCard(),
                      const SizedBox(height: 100), // Extra padding for bottom nav
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
      floatingActionButton: _buildPrimaryFAB(),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ProfileHeaderSkeleton(),
          const SizedBox(height: 16),
          const MetricCardSkeleton(),
          const SizedBox(height: 16),
          const CardSkeleton(itemCount: 5),
          const SizedBox(height: 16),
          const CardSkeleton(itemCount: 3),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    final profile = _currentProfile ?? UserProfile.defaultProfile();
    
    return ProfileHeader(
      name: profile.displayName,
      location: profile.location.isNotEmpty ? profile.location : 'Location not set',
      profileImageUrl: profile.profileImageUrl,
      verificationStatus: profile.verificationStatus,
      onEditTap: () => _navigateToEditProfile(),
    );
  }

  Widget _carbonProfileCard() {
    final profile = _currentProfile ?? UserProfile.defaultProfile();
    
    return AgriCard(
      title: '🌿 Carbon Profile',
      subtitle: 'Trust in your carbon calculations',
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: const Color(0xFF2E7D32), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Carbon Credits',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      '${profile.carbonCredits.toStringAsFixed(1)} t CO₂',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Icon(Icons.psychology, color: const Color(0xFF2E7D32), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confidence Score',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Row(
                      children: [
                        Text(
                          '${profile.trustScore}% ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          '(${profile.confidenceLevel})',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getConfidenceColor(profile.confidenceLevel),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, color: const Color(0xFF2E7D32), size: 16),
              const SizedBox(width: 6),
              Text(
                'Updated ${profile.lastCarbonUpdateDisplay}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _farmDetailsCard() {
    final profile = _currentProfile ?? UserProfile.defaultProfile();
    
    return AgriCard(
      title: '🌱 Farm Details',
      subtitle: 'Information used for carbon calculations',
      child: Column(
        children: [
          _buildDetailRow('Farm Area', profile.formattedFarmArea),
          _buildDetailRow('Primary Crop', profile.primaryCrop.isNotEmpty ? profile.primaryCrop : 'Not set'),
          _buildDetailRow('Farming Type', profile.farmingType.isNotEmpty ? profile.farmingType : 'Not set'),
          _buildDetailRow('Irrigation', profile.irrigation.isNotEmpty ? profile.irrigation : 'Not set'),
          _buildDetailRow('Experience', profile.farmingExperienceDisplay),
        ],
      ),
    );
  }

  Widget _verificationCard() {
    final profile = _currentProfile ?? UserProfile.defaultProfile();
    
    return AgriCard(
      title: '🔍 Verification Status',
      subtitle: 'Transparency builds trust',
      child: Column(
        children: [
          VerificationItem(
            label: 'Identity verified',
            isCompleted: profile.identityVerified,
          ),
          VerificationItem(
            label: 'Satellite data verified',
            isCompleted: profile.satelliteDataVerified,
          ),
          VerificationItem(
            label: 'Activity photos submitted',
            isCompleted: profile.activityPhotosSubmitted,
            isPending: profile.seasonalValidationPending,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TrustSignal(
                text: 'Verified data',
                icon: Icons.verified,
              ),
              TrustSignal(
                text: 'Satellite & farm data',
                icon: Icons.satellite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToEditProfile(),
      backgroundColor: const Color(0xFF2E7D32),
      icon: const Icon(Icons.edit, color: Colors.white),
      label: const Text(
        'Edit Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      tooltip: 'Edit Profile',
    );
  }

  Color _getConfidenceColor(String level) {
    switch (level) {
      case 'High':
        return const Color(0xFF2E7D32);
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(context, AppRoutes.editProfile);
  }
}
