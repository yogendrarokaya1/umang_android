import 'package:fitness_tracker/app/routes/app_routes.dart';
import 'package:fitness_tracker/features/auth/presentation/pages/login_page.dart';
import 'package:fitness_tracker/features/auth/presentation/state/auth_state.dart';
import 'package:fitness_tracker/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/presentation/state/profile_state.dart';
import 'package:fitness_tracker/features/profile/presentation/view_model/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _heightController = TextEditingController();
  final _bioController = TextEditingController();

  String _gender = 'prefer_not_to_say';
  String _fitnessLevel = 'beginner';
  String _activityLevel = 'sedentary';
  String _weightUnit = 'kg';

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).getMyProfile();
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _populateForm(ProfileEntity profile) {
    if (_isInit) return;
    _isInit = true;
    _heightController.text = profile.heightCm?.toString() ?? '';
    _bioController.text = profile.bio ?? '';
    if (profile.gender != null && profile.gender!.isNotEmpty) _gender = profile.gender!;
    if (profile.fitnessLevel.isNotEmpty) _fitnessLevel = profile.fitnessLevel;
    if (profile.activityLevel.isNotEmpty) _activityLevel = profile.activityLevel;
    if (profile.preferredWeightUnit.isNotEmpty) _weightUnit = profile.preferredWeightUnit;
  }

  void _submitUpdate() {
    if (!_formKey.currentState!.validate()) return;
    
    final currentProfile = ref.read(profileViewModelProvider).profile;
    if (currentProfile == null) return;

    final updatedProfile = ProfileEntity(
      id: currentProfile.id,
      userId: currentProfile.userId,
      gender: _gender,
      dateOfBirth: currentProfile.dateOfBirth,
      heightCm: double.tryParse(_heightController.text),
      bio: _bioController.text,
      fitnessLevel: _fitnessLevel,
      activityLevel: _activityLevel,
      preferredWeightUnit: _weightUnit,
      preferredHeightUnit: currentProfile.preferredHeightUnit,
      age: currentProfile.age,
    );

    ref.read(profileViewModelProvider.notifier).updateMyProfile(updatedProfile).then((_) {
      final state = ref.read(profileViewModelProvider);
      if (state.status == ProfileStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
      } else if (state.status == ProfileStatus.error) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.errorMessage}'), backgroundColor: Colors.red),
        );
      }
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authViewModelProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    // Listen for logout
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        AppRoutes.pushAndRemoveUntil(context, const LoginScreen());
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fitness Profile', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: _buildBody(profileState, authState),
    );
  }

  Widget _buildBody(ProfileState state, AuthState authState) {
    if (state.status == ProfileStatus.loading && state.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ProfileStatus.error && state.profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.errorMessage}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(profileViewModelProvider.notifier).getMyProfile(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final profile = state.profile;
    if (profile == null) {
      return const Center(child: Text('No profile data available.'));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateForm(profile);
    });

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Account Info Section ---
              if (authState.user != null) ...[
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: authState.user!.profilePicture != null 
                          ? NetworkImage(authState.user!.profilePicture!) 
                          : null,
                        child: authState.user!.profilePicture == null 
                          ? Text(
                              authState.user!.fullName.isNotEmpty 
                                ? authState.user!.fullName[0].toUpperCase() 
                                : 'U', 
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                            ) 
                          : null,
                      ),
                      const SizedBox(height: 12),
                      Text(authState.user!.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('@${authState.user!.username}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                        child: Text(authState.user!.email, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              _buildSectionTitle('Body Stats & Preferences'),
               Text(
                'Update your body parameters for better tracking',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Personal'),
              _buildTextField('Height (cm)', _heightController, isNumber: true),
              const SizedBox(height: 16),
              _buildDropdown('Gender', _gender, ['male', 'female', 'other', 'prefer_not_to_say'], (val) {
                if (val != null) setState(() => _gender = val);
              }),
              const SizedBox(height: 16),
               _buildTextField('Bio (Optional)', _bioController, maxLines: 3),
              const SizedBox(height: 32),

              _buildSectionTitle('Fitness Preferences'),
              _buildDropdown('Fitness Level', _fitnessLevel, ['beginner', 'intermediate', 'advanced'], (val) {
                if (val != null) setState(() => _fitnessLevel = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown('Activity Level', _activityLevel, ['sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active'], (val) {
                if (val != null) setState(() => _activityLevel = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown('Preferred Unit', _weightUnit, ['kg', 'lbs'], (val) {
                if (val != null) setState(() => _weightUnit = val);
              }),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: state.status == ProfileStatus.loading ? null : _submitUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: state.status == ProfileStatus.loading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((opt) {
        return DropdownMenuItem(
          value: opt,
          child: Text(opt.replaceAll('_', ' ').replaceFirst(opt[0], opt[0].toUpperCase())),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}
