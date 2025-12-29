import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/onboarding_progress.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../../shared/widgets/agri_card.dart';
import '../../shared/widgets/agri_button.dart';

/// BasicFarmProfileScreen - UI-compliant onboarding profile screen
/// Follows Core UI Rules:
/// - 3-second understanding test
/// - Clear visual hierarchy
/// - One primary action
/// - Proper card design (18px border radius)
/// - Fast, purposeful animations (250ms)
class BasicFarmProfileScreen extends StatefulWidget {
  const BasicFarmProfileScreen({Key? key}) : super(key: key);

  @override
  State<BasicFarmProfileScreen> createState() => _BasicFarmProfileScreenState();
}

class _BasicFarmProfileScreenState extends State<BasicFarmProfileScreen>
    with TickerProviderStateMixin {
  // Form data
  String selectedCrop = 'Rice';
  String landSize = '1–2 acres';
  String farmingType = 'Conventional';
  
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  
  // Form validation
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onProfileSaved() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate save process
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      // Success feedback following UI rules
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Farm profile saved successfully!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate with animation
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    const OnboardingProgress(
                      currentStep: 3,
                      totalSteps: 4,
                    ),

                    const SizedBox(height: 32),

                    // Main title (follows typography rules: 20-22px, SemiBold)
                    Text(
                      'Your Farm Details',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF2E7D32),
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle (14-15px body text)
                    Text(
                      'Almost done! This helps us give you better advice',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                    ),

                    const SizedBox(height: 32),

                    // Main form content
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Main Crop Selection
                              _buildSectionCard(
                                title: '🌾 Main Crop',
                                subtitle: 'Most farmers select their main crop',
                                child: FarmDropdownField(
                                  label: 'Primary Crop',
                                  hint: 'Select your main crop',
                                  icon: Icons.grass,
                                  value: selectedCrop,
                                  items: const [
                                    'Rice',
                                    'Wheat',
                                    'Cotton',
                                    'Sugarcane',
                                    'Vegetables',
                                    'Maize',
                                    'Pulses',
                                  ],
                                  onChanged: (val) => setState(() => selectedCrop = val),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Land Size
                              _buildSectionCard(
                                title: '📏 Land Size',
                                subtitle: 'Most farmers have 1–5 acres',
                                child: FarmDropdownField(
                                  label: 'Farm Area',
                                  hint: 'Select your land size',
                                  icon: Icons.landscape,
                                  value: landSize,
                                  items: const [
                                    'Less than 1 acre',
                                    '1–2 acres',
                                    '3–5 acres',
                                    'More than 5 acres',
                                  ],
                                  onChanged: (val) => setState(() => landSize = val),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Farming Type
                              _buildSectionCard(
                                title: '🌱 Farming Method',
                                subtitle: 'Choose your farming approach',
                                child: FarmDropdownField(
                                  label: 'Farming Type',
                                  hint: 'Select your method',
                                  icon: Icons.eco,
                                  value: farmingType,
                                  items: const [
                                    'Conventional',
                                    'Organic',
                                    'Mixed',
                                    'Sustainable',
                                  ],
                                  onChanged: (val) => setState(() => farmingType = val),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Primary action button (follows button rules)
                              AgriButton(
                                text: 'Complete Setup',
                                onPressed: _onProfileSaved,
                                isLoading: _isLoading,
                                type: ButtonType.primary,
                                icon: Icons.check,
                              ),

                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return AgriCard(
      title: title,
      subtitle: subtitle,
      child: child,
    );
  }
}

/// FarmDropdownField - UI-compliant dropdown component
class FarmDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const FarmDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (14-15px body text)
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 8),
        // Dropdown field
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => onChanged(val!),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
            filled: true,
            fillColor: const Color(0xFFF0F8F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
