import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  final String? initialRole;
  const RegisterPage({super.key, this.initialRole});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _selectedRole;
  int _currentStep = 0;
  String _selectedCity = 'douala';
  String _vehicleType = 'motorcycle';
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole ?? 'client';
  }

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _vehiclePlateCtrl = TextEditingController();

  String? _idCardPath;
  String? _licensePath;
  String? _photoPath;

  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'id') _idCardPath = image.path;
        if (type == 'license') _licensePath = image.path;
        if (type == 'photo') _photoPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg.tr()),
                  backgroundColor: AppTheme.primaryRed,
                ),
              );
            },
            emailVerificationRequired: (email) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('auth.registration_success'.tr()),
                  backgroundColor: AppTheme.green,
                ),
              );
              context.go(
                '/auth/verify-email?email=${Uri.encodeComponent(email)}',
              );
            },
            driverRegistrationSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('auth.driver_pending_validation'.tr()),
                  backgroundColor: AppTheme.green,
                  duration: const Duration(seconds: 4),
                ),
              );
              context.go('/auth/login?mode=delivery');
            },
            authenticated: (_, _, _) {
              context.go('/client');
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            border: Border.all(color: context.colors.line),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: context.colors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'auth.register_btn'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.colors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _CELogo(),
                            const SizedBox(height: 28),
                            // Step indicator
                            Row(
                              children: List.generate(
                                _selectedRole == 'delivery' ? 3 : 2,
                                (i) => Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: i < 2 ? 6 : 0,
                                    ),
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: i <= _currentStep
                                          ? AppTheme.primaryRed
                                          : AppTheme.lineSoft,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            if (_currentStep == 0) ...[
                              Text(
                                'onboarding.welcome'.tr(),
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildRoleCard(
                                title: 'auth.role_client_title'.tr(),
                                subtitle: 'auth.role_client_subtitle'.tr(),
                                icon: '🍽️',
                                value: 'client',
                              ),
                              const SizedBox(height: 12),
                              _buildRoleCard(
                                title: 'auth.role_delivery_title'.tr(),
                                subtitle: 'auth.role_delivery_subtitle'.tr(),
                                icon: '🛵',
                                value: 'delivery',
                              ),
                            ],

                            if (_currentStep == 1) ...[
                              Text(
                                'auth.personal_info'.tr(),
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.6,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildInput(
                                'auth.name'.tr(),
                                Icons.person_outline_rounded,
                                controller: _nameCtrl,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
                                'auth.email'.tr(),
                                Icons.email_outlined,
                                controller: _emailCtrl,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
                                'auth.phone_number'.tr(),
                                Icons.phone_outlined,
                                controller: _phoneCtrl,
                              ),
                              const SizedBox(height: 12),
                              _buildInput(
                                'auth.password'.tr(),
                                Icons.lock_outline_rounded,
                                obscure: !_passwordVisible,
                                controller: _passwordCtrl,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppTheme.muted,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _passwordVisible = !_passwordVisible,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildCityDropdown(),
                              if (_selectedRole == 'delivery') ...[
                                const SizedBox(height: 12),
                                _buildVehicleTypeDropdown(),
                                const SizedBox(height: 12),
                                _buildInput(
                                  'auth.vehicle_plate_label'.tr(),
                                  Icons.vignette_outlined,
                                  controller: _vehiclePlateCtrl,
                                ),
                              ],
                            ],

                            if (_currentStep == 2 &&
                                _selectedRole == 'delivery') ...[
                              Text(
                                'auth.documents_title'.tr(),
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.6,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'auth.documents_subtitle'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.muted,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildUploadButton(
                                'auth.photo'.tr(),
                                _photoPath,
                                () => _pickImage('photo'),
                              ),
                              const SizedBox(height: 10),
                              _buildUploadButton(
                                'auth.id_card'.tr(),
                                _idCardPath,
                                () => _pickImage('id'),
                              ),
                              const SizedBox(height: 10),
                              _buildUploadButton(
                                'auth.license'.tr(),
                                _licensePath,
                                () => _pickImage('license'),
                              ),
                            ],

                            const SizedBox(height: 32),

                            // Continue button
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        HapticFeedback.selectionClick();
                                        final isLast = _selectedRole == 'client'
                                            ? _currentStep == 1
                                            : _currentStep == 2;
                                        if (isLast) {
                                          HapticFeedback.heavyImpact();

                                          final password = _passwordCtrl.text;
                                          final passRegex = RegExp(
                                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$',
                                          );
                                          if (!passRegex.hasMatch(password)) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'auth.password_complexity'
                                                      .tr(),
                                                ),
                                                backgroundColor:
                                                    AppTheme.primaryRed,
                                              ),
                                            );
                                            return;
                                          }

                                          if (_selectedRole == 'client') {
                                            context.read<AuthBloc>().add(
                                              AuthEvent.register(
                                                name: _nameCtrl.text.trim(),
                                                email: _emailCtrl.text.trim(),
                                                password: _passwordCtrl.text,
                                                city: _selectedCity,
                                              ),
                                            );
                                          } else {
                                            // Validate fields for driver
                                            if (_photoPath == null ||
                                                _idCardPath == null ||
                                                _licensePath == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'auth.upload_all_docs'.tr(),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            context.read<AuthBloc>().add(
                                              AuthEvent.registerDriver(
                                                name: _nameCtrl.text.trim(),
                                                email: _emailCtrl.text.trim(),
                                                phone: _phoneCtrl.text.trim(),
                                                password: _passwordCtrl.text,
                                                city: _selectedCity,
                                                vehicleType: _vehicleType,
                                                vehiclePlate: _vehiclePlateCtrl
                                                    .text
                                                    .trim(),
                                                idCardPath: _idCardPath!,
                                                licensePath: _licensePath!,
                                                photoPath: _photoPath!,
                                              ),
                                            );
                                          }
                                        } else {
                                          setState(() => _currentStep++);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryRed,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _selectedRole == 'client'
                                            ? (_currentStep == 1
                                                  ? 'S\'inscrire'
                                                  : 'Suivant')
                                            : (_currentStep == 2
                                                  ? 'S\'inscrire'
                                                  : 'Suivant'),
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/auth/login'),
                                child: Text(
                                  'auth.have_account'.tr(),
                                  style: GoogleFonts.inter(
                                    color: AppTheme.primaryRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (_currentStep > 0) ...[
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () => setState(() => _currentStep--),
                                child: Text(
                                  'Retour',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppTheme.muted,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
  }) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedRole = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.redSoft : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryRed : AppTheme.lineSoft,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [] : AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppTheme.primaryRed : AppTheme.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primaryRed,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    IconData icon, {
    bool obscure = false,
    TextEditingController? controller,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.inkSoft, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.muted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.ink, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCity,
      onChanged: (val) => setState(() => _selectedCity = val!),
      items: [
            {'label': 'Douala', 'value': 'douala'},
            {'label': 'Yaoundé', 'value': 'yaounde'},
          ]
          .map(
            (city) => DropdownMenuItem(
              value: city['value'],
              child: Text(
                city['label']!,
                style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
              ),
            ),
          )
          .toList(),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'auth.city'.tr(),
        labelStyle: GoogleFonts.inter(color: AppTheme.inkSoft, fontSize: 14),
        prefixIcon: const Icon(
          Icons.location_city_outlined,
          color: AppTheme.muted,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.ink, width: 2),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String label, String? path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: path != null ? AppTheme.green : AppTheme.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              path != null
                  ? Icons.check_circle_rounded
                  : Icons.cloud_upload_outlined,
              color: path != null ? AppTheme.green : AppTheme.muted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                path != null ? 'auth.document_selected'.tr() : label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: path != null ? AppTheme.green : AppTheme.inkSoft,
                  fontWeight: path != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (path != null)
              const Icon(Icons.edit_outlined, size: 16, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _vehicleType,
      onChanged: (val) => setState(() => _vehicleType = val!),
      items: [
        DropdownMenuItem(
          value: 'motorcycle',
          child: Text(
            'delivery.vehicle_motorcycle'.tr(),
            style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
          ),
        ),
        DropdownMenuItem(
          value: 'bicycle',
          child: Text(
            'delivery.vehicle_bicycle'.tr(),
            style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
          ),
        ),
        DropdownMenuItem(
          value: 'car',
          child: Text(
            'delivery.vehicle_car'.tr(),
            style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
          ),
        ),
        DropdownMenuItem(
          value: 'on_foot',
          child: Text(
            'delivery.vehicle_on_foot'.tr(),
            style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
          ),
        ),
      ].toList(),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'delivery.vehicle_type'.tr(),
        labelStyle: GoogleFonts.inter(color: AppTheme.inkSoft, fontSize: 14),
        prefixIcon: const Icon(
          Icons.directions_bike_rounded,
          color: AppTheme.muted,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.ink, width: 2),
        ),
      ),
    );
  }
}

class _CELogo extends StatelessWidget {
  const _CELogo();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}
