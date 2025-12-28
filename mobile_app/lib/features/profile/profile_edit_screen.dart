import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_routes.dart';
import '../../../models/user_profile.dart';
import '../../../services/profile_service.dart';
import '../../../services/firebase_user_service.dart';
import '../../../shared/widgets/agri_bottom_nav.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  UserProfile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      // Get profile data
      final profile = await ProfileService.getUserProfile();
      
      // Get Firebase Auth phone number if profile phone is empty
      final firebasePhone = FirebaseUserService.getCurrentUserPhone();
      final phoneNumber = profile.phone.isNotEmpty ? profile.phone : firebasePhone ?? '';
      
      setState(() {
        _currentProfile = profile;
        _nameController.text = profile.name;
        _locationController.text = profile.location;
        _phoneController.text = phoneNumber; // Use Firebase phone or profile phone
        _bioController.text = profile.bio;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
      // Try to at least get Firebase phone number
      final firebasePhone = FirebaseUserService.getCurrentUserPhone();
      setState(() {
        _phoneController.text = firebasePhone ?? '';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProfile = _currentProfile?.copyWith(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
      ) ?? UserProfile.empty();

      await ProfileService.saveUserProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving profile. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
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
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileImageSection(),
                    const SizedBox(height: 32),
                    _buildFormFields(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 58,
              backgroundColor: Colors.green.shade100,
              backgroundImage: _currentProfile?.profileImageUrl.isNotEmpty == true
                  ? NetworkImage(_currentProfile!.profileImageUrl) as ImageProvider
                  : null,
              child: _currentProfile?.profileImageUrl.isEmpty != false
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.green.shade600,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _locationController,
          label: 'Location',
          hint: 'Enter your location (e.g., Pune, Maharashtra)',
          icon: Icons.location_on,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Location is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildReadOnlyPhoneField(),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          hint: 'Tell us about yourself...',
          icon: Icons.info_outline,
          maxLines: 4,
          maxLength: 200,
        ),
        const SizedBox(height: 40),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.green),
            filled: true,
            fillColor: Colors.white,
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
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          readOnly: true, // Make it read-only since it comes from Firebase Auth
          decoration: InputDecoration(
            hintText: 'Phone number from login',
            prefixIcon: const Icon(Icons.phone, color: Colors.green),
            filled: true,
            fillColor: Colors.grey.shade100,
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
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            suffixIcon: Icon(
              Icons.lock,
              color: Colors.grey.shade600,
              size: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Phone number is set during login and cannot be changed',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
