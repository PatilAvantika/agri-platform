import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../services/farm_info_service.dart';
import '../../services/location_service.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../../shared/widgets/agri_card.dart';
import '../../shared/widgets/agri_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Information Controllers
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  // Farm Information Controllers
  final _farmAreaController = TextEditingController();
  final _farmingExperienceController = TextEditingController();

  // Dropdown selections
  String _selectedFarmAreaUnit = 'Acres';
  String _selectedFarmingType = '';
  String _selectedIrrigation = '';
  String _selectedSoilType = '';
  List<String> _selectedCrops = [];

  // State variables
  bool _isLoading = false;
  bool _isGettingLocation = false;
  UserProfile? _currentProfile;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

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
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _farmAreaController.dispose();
    _farmingExperienceController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ProfileService.getUserProfile();
      
      setState(() {
        _currentProfile = profile;
        _nameController.text = profile.name;
        _locationController.text = profile.location;
        _phoneController.text = profile.phone;
        _bioController.text = profile.bio;
        _farmAreaController.text = profile.farmArea.toString();
        _farmingExperienceController.text = profile.farmingExperience.toString();
        _selectedFarmAreaUnit = profile.farmAreaUnit;
        _selectedFarmingType = profile.farmingType;
        _selectedIrrigation = profile.irrigation;
        _selectedSoilType = profile.soilType;
        _selectedCrops = List.from(profile.cropTypes);
      });
      
      _animationController.forward();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      // Simple location input for now - GPS functionality can be added later
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _locationController.text = 'Location detected';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📍 Location updated! (Manual input required)'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Please enter your location manually'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final farmArea = double.parse(_farmAreaController.text.trim());
      final farmingExperience = int.parse(_farmingExperienceController.text.trim());

      // Validate farm information
      final errors = FarmInfoService.validateFarmInfo(
        farmArea: farmArea,
        farmAreaUnit: _selectedFarmAreaUnit,
        cropTypes: _selectedCrops,
        farmingType: _selectedFarmingType,
        irrigation: _selectedIrrigation,
        soilType: _selectedSoilType,
        farmingExperience: farmingExperience,
      );

      if (errors.isNotEmpty) {
        _showValidationErrors(errors);
        return;
      }

      // Create updated profile
      final updatedProfile = _currentProfile?.copyWith(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        farmArea: farmArea,
        farmAreaUnit: _selectedFarmAreaUnit,
        cropTypes: _selectedCrops,
        farmingType: _selectedFarmingType,
        irrigation: _selectedIrrigation,
        soilType: _selectedSoilType,
        farmingExperience: farmingExperience,
        lastCarbonUpdate: DateTime.now(),
      ) ?? UserProfile.empty();

      // Calculate trust score
      final trustScore = FarmInfoService.calculateTrustScore(updatedProfile);
      final profileWithTrustScore = updatedProfile.copyWith(trustScore: trustScore);

      await ProfileService.saveUserProfile(profileWithTrustScore);
      await FarmInfoService.saveFarmInfo(profileWithTrustScore);

      if (mounted) {
        // Success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Profile saved successfully!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error saving profile. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showValidationErrors(Map<String, String> errors) {
    final errorMessage = errors.values.join('\n');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please fix these issues'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCropSelectionDialog() {
    final availableCrops = FarmInfoService.getAvailableCrops();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Crops'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableCrops.length,
            itemBuilder: (context, index) {
              final crop = availableCrops[index];
              final isSelected = _selectedCrops.contains(crop);
              
              return CheckboxListTile(
                title: Text(crop),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedCrops.add(crop);
                    } else {
                      _selectedCrops.remove(crop);
                    }
                  });
                  Navigator.pop(context);
                  _showCropSelectionDialog();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32)),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildPersonalInfoSection(),
                          const SizedBox(height: 20),
                          _buildFarmAreaSection(),
                          const SizedBox(height: 20),
                          _buildCropSelectionSection(),
                          const SizedBox(height: 20),
                          _buildFarmingDetailsSection(),
                          const SizedBox(height: 20),
                          _buildSaveButton(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }

  Widget _buildPersonalInfoSection() {
    return AgriCard(
      title: '👤 Personal Information',
      subtitle: 'Your basic details',
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Location',
              hintText: 'Enter your location',
              prefixIcon: const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
              suffixIcon: _isGettingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location, color: Color(0xFF2E7D32)),
                      tooltip: 'Use current location',
                    ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Location is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: 'Enter your mobile number',
              prefixIcon: Icon(Icons.phone, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mobile number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'About You (Optional)',
              hintText: 'Tell us about your farming journey...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmAreaSection() {
    return AgriCard(
      title: '🌾 Farm Area',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _farmAreaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Farm Area',
                    hintText: 'Enter farm area',
                    prefixIcon: Icon(Icons.landscape, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Farm area is required';
                    }
                    final area = double.tryParse(value.trim());
                    if (area == null || area <= 0) {
                      return 'Please enter a valid area';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFarmAreaUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: FarmInfoService.getFarmAreaUnits()
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFarmAreaUnit = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCropSelectionSection() {
    return AgriCard(
      title: '🌱 Crop Selection',
      subtitle: 'Select crops you grow on your farm',
      child: Column(
        children: [
          GestureDetector(
            onTap: _showCropSelectionDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.agriculture, color: const Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedCrops.isNotEmpty
                          ? '${_selectedCrops.length} crops selected'
                          : 'Select crops',
                      style: TextStyle(
                        color: _selectedCrops.isNotEmpty 
                            ? Colors.black87 
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          if (_selectedCrops.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedCrops.map((crop) {
                return Chip(
                  label: Text(crop),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _selectedCrops.remove(crop);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFarmingDetailsSection() {
    return AgriCard(
      title: '🚜 Farming Details',
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedFarmingType.isNotEmpty ? _selectedFarmingType : null,
            decoration: const InputDecoration(
              labelText: 'Farming Type',
              hintText: 'Select farming type',
              prefixIcon: Icon(Icons.nature, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getFarmingTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFarmingType = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select farming type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedIrrigation.isNotEmpty ? _selectedIrrigation : null,
            decoration: const InputDecoration(
              labelText: 'Irrigation Type',
              hintText: 'Select irrigation type',
              prefixIcon: Icon(Icons.water_drop, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getIrrigationTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedIrrigation = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select irrigation type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedSoilType.isNotEmpty ? _selectedSoilType : null,
            decoration: const InputDecoration(
              labelText: 'Soil Type',
              hintText: 'Select soil type',
              prefixIcon: Icon(Icons.terrain, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            items: FarmInfoService.getSoilTypes()
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSoilType = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select soil type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _farmingExperienceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Farming Experience (years)',
              hintText: 'Enter years of farming experience',
              prefixIcon: Icon(Icons.work, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Farming experience is required';
              }
              final experience = int.tryParse(value.trim());
              if (experience == null || experience < 0) {
                return 'Please enter valid experience';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return AgriButton(
      text: 'Save Profile',
      onPressed: _saveProfile,
      isLoading: _isLoading,
      type: ButtonType.primary,
    );
  }
}
