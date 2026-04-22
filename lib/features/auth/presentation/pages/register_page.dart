// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String _selectedRole = 'client';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
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
                        color: Colors.white,
                        border: Border.all(color: AppTheme.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: AppTheme.ink),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Inscription à ClicEat',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
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
                        // Step indicator
                        Row(
                          children: List.generate(
                            _selectedRole == 'delivery' ? 3 : 2,
                            (i) => Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
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
                            'Choisissez votre profil',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.ink,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildRoleCard(
                            title: 'Client',
                            subtitle: 'Commander vos plats préférés',
                            icon: '🍽️',
                            value: 'client',
                          ),
                          const SizedBox(height: 12),
                          _buildRoleCard(
                            title: 'Livreur',
                            subtitle: 'Travailler comme livreur indépendant',
                            icon: '🛵',
                            value: 'delivery',
                          ),
                        ],

                        if (_currentStep == 1) ...[
                          Text(
                            'Informations\npersonnelles',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.ink,
                              letterSpacing: -0.6,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInput('Nom Complet', Icons.person_outline_rounded),
                          const SizedBox(height: 12),
                          _buildInput('Email', Icons.email_outlined),
                          const SizedBox(height: 12),
                          _buildInput('Numéro de téléphone', Icons.phone_outlined),
                          const SizedBox(height: 12),
                          _buildInput('Mot de passe', Icons.lock_outline_rounded,
                              obscure: true),
                        ],

                        if (_currentStep == 2 && _selectedRole == 'delivery') ...[
                          Text(
                            'Documents\nlivreur',
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
                            'Vos documents seront vérifiés sous 48h.',
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppTheme.muted),
                          ),
                          const SizedBox(height: 20),
                          _buildUploadButton('Photo de la CNI / Passeport'),
                          const SizedBox(height: 10),
                          _buildUploadButton('Permis de conduire (A)'),
                          const SizedBox(height: 10),
                          _buildUploadButton('Papiers du véhicule (Carte Grise)'),
                        ],

                        const SizedBox(height: 32),

                        // Continue button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              final isLast = _selectedRole == 'client'
                                  ? _currentStep == 1
                                  : _currentStep == 2;
                              if (isLast) {
                                HapticFeedback.heavyImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Compte créé avec succès !'),
                                    backgroundColor: AppTheme.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                                context.go('/auth/login?mode=client');
                              } else {
                                setState(() => _currentStep++);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryRed,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              _currentStep ==
                                      (_selectedRole == 'client' ? 1 : 2)
                                  ? 'Terminer l\'inscription'
                                  : 'Suivant',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
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
                                  fontSize: 14, color: AppTheme.muted),
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
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.primaryRed, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
      ),
      child: TextField(
        obscureText: obscure,
        style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.muted, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String title) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sélecteur de fichier pour: $title')));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.line, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.upload_file_rounded,
                  color: AppTheme.primaryRed, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.inkSoft,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.mutedLight, size: 20),
          ],
        ),
      ),
    );
  }
}
