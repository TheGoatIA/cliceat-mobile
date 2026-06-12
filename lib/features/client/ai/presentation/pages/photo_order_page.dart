import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/client/cart/presentation/bloc/cart_cubit.dart';
import '../cubit/ai_cubit.dart';

class PhotoOrderPage extends StatefulWidget {
  final String? restaurantId;

  const PhotoOrderPage({super.key, this.restaurantId});

  @override
  State<PhotoOrderPage> createState() => _PhotoOrderPageState();
}

class _PhotoOrderPageState extends State<PhotoOrderPage> {
  XFile? _imageFile;
  final _picker = ImagePicker();
  final Map<String, int> _quantities = {};

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.lightImpact();
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1280,
    );
    if (picked != null) {
      setState(() {
        _imageFile = picked;
        _quantities.clear();
      });
      // Reset cubit state
      if (mounted) {
        context.read<AiCubit>().initGastroGuide(); // reset to idle-like
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppTheme.primaryRed,
                ),
                title: Text(
                  'Prendre une photo',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppTheme.primaryRed,
                ),
                title: Text(
                  'Choisir depuis la galerie',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _analyze() async {
    if (_imageFile == null) return;
    HapticFeedback.mediumImpact();

    final bytes = await _imageFile!.readAsBytes();
    final filename = _imageFile!.name;
    final restaurantId = widget.restaurantId ?? '';

    if (!mounted) return;
    await context.read<AiCubit>().analyzePhotoOrder(
      imageBytes: bytes,
      filename: filename,
      restaurantId: restaurantId,
    );
  }

  Future<void> _addToCart(List<Map<String, dynamic>> items) async {
    final cart = context.read<CartCubit>();
    final restaurantId = widget.restaurantId ?? '';
    for (final item in items) {
      final qty = _quantities[item['id'] as String? ?? item['name'] as String? ?? ''] ?? 1;
      if (qty > 0) {
        for (var i = 0; i < qty; i++) {
          await cart.addItem(
            restaurantId: restaurantId,
            itemId: item['id'] as String? ?? '',
            name: item['name'] as String? ?? '',
            price: (item['price'] as num?)?.toDouble() ?? 0.0,
          );
        }
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ai.add_to_cart'.tr()),
          backgroundColor: AppTheme.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'ai.photo_order_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocConsumer<AiCubit, AiState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg.tr()),
                  backgroundColor: AppTheme.errorColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image picker area
                _buildImageArea(),
                const SizedBox(height: 20),

                // Analyze button
                state.maybeWhen(
                  loading: () => const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.primaryRed,
                        ),
                        SizedBox(height: 12),
                        Text('Gemini analyse votre photo...'),
                      ],
                    ),
                  ),
                  orElse: () => SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _imageFile != null ? _analyze : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        disabledBackgroundColor: AppTheme.line,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'ai.analyze'.tr(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Results
                state.maybeWhen(
                  photoOrderResult: (items, message) =>
                      _buildResults(items),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageArea() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _imageFile != null ? AppTheme.primaryRed : AppTheme.line,
            width: _imageFile != null ? 2 : 1,
            style: _imageFile != null ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.redSoft,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 32,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ai.photo_order_hint'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyer pour choisir',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.mutedLight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResults(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Plats identifiés',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildItemCard(item)),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => _addToCart(items),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'ai.add_to_cart'.tr(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final id = item['id'] as String? ?? item['name'] as String? ?? '';
    final name = item['name'] as String? ?? '';
    final confidence = ((item['confidence'] as num?) ?? 0.8).toDouble();
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final qty = _quantities[id] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.ink,
                  ),
                ),
              ),
              if (price > 0)
                Text(
                  '${price.toStringAsFixed(0)} FCFA',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.primaryRed,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Confidence bar
          Row(
            children: [
              Text(
                'Confiance',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: confidence,
                    backgroundColor: AppTheme.line,
                    color: confidence >= 0.8
                        ? AppTheme.green
                        : confidence >= 0.6
                            ? AppTheme.orange
                            : AppTheme.errorColor,
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(confidence * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quantity selector
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Qté :',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.inkSoft,
                ),
              ),
              const SizedBox(width: 12),
              _buildQtyButton(
                Icons.remove,
                () {
                  setState(() {
                    _quantities[id] = (qty - 1).clamp(0, 99);
                  });
                },
              ),
              const SizedBox(width: 12),
              Text(
                '$qty',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(width: 12),
              _buildQtyButton(
                Icons.add,
                () {
                  setState(() {
                    _quantities[id] = (qty + 1).clamp(0, 99);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.redSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primaryRed),
      ),
    );
  }
}
