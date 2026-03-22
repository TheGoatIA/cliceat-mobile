// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String _selectedRole = 'client'; // 'client' or 'delivery'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription à ClicEat'),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              HapticFeedback.selectionClick();
              if (_currentStep == 0) {
                setState(() => _currentStep += 1);
              } else if (_currentStep == 1 && _selectedRole == 'delivery') {
                setState(() => _currentStep += 1);
              } else {
                // Submit Form
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compte créé avec succès !')));
                context.go('/login');
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              } else {
                context.pop();
              }
            },
            steps: [
              Step(
                title: const Text('Choisissez votre profil'),
                content: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Client (Commander à manger)'),
                      value: 'client',
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Livreur Indépendant (Travailler)'),
                      value: 'delivery',
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('Informations personnelles'),
                content: Column(
                  children: [
                    _buildTextField('Nom Complet', Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField('Email', Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField('Numéro de téléphone', Icons.phone),
                    const SizedBox(height: 16),
                    _buildTextField('Mot de passe', Icons.lock, obscureText: true),
                  ],
                ),
                isActive: _currentStep >= 1,
              ),
              if (_selectedRole == 'delivery')
                Step(
                  title: const Text('Documents Livreur'),
                  content: Column(
                    children: [
                      _buildUploadButton('Photo de la CNI / Passeport'),
                      const SizedBox(height: 16),
                      _buildUploadButton('Permis de conduire (A)'),
                      const SizedBox(height: 16),
                      _buildUploadButton('Papiers du véhicule (Carte Grise)'),
                      const SizedBox(height: 16),
                      const Text('Vos documents seront vérifiés par notre équipe sous 48h.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                ),
            ],
            controlsBuilder: (context, details) {
              final isLastStep = _selectedRole == 'client' ? _currentStep == 1 : _currentStep == 2;
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: isLastStep ? 'Terminer l\'inscription' : 'Suivant',
                        onPressed: details.onStepContinue ?? () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Retour'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUploadButton(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
      ),
      child: TextButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sélecteur de fichier pour: $title')));
        },
        icon: const Icon(Icons.upload_file),
        label: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
    );
  }
}
