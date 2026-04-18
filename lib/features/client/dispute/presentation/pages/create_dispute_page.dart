import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/dispute/presentation/bloc/dispute_cubit.dart';

class CreateDisputePage extends StatefulWidget {
  final String orderId;

  const CreateDisputePage({super.key, required this.orderId});

  @override
  State<CreateDisputePage> createState() => _CreateDisputePageState();
}

class _CreateDisputePageState extends State<CreateDisputePage> {
  final _descriptionController = TextEditingController();
  String _reason = 'wrong_item';
  final List<File> _images = [];
  final _picker = ImagePicker();

  final List<Map<String, String>> _reasons = [
    {'value': 'wrong_item', 'label': 'dispute.reason_wrong_item'},
    {'value': 'missing_item', 'label': 'dispute.reason_missing_item'},
    {'value': 'late_delivery', 'label': 'dispute.reason_late_delivery'},
    {'value': 'quality_issue', 'label': 'dispute.reason_quality_issue'},
    {'value': 'other', 'label': 'dispute.reason_other'},
  ];

  Future<void> _pickImage() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('dispute.max_images'.tr())),
      );
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _images.add(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DisputeCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('dispute.create_title'.tr()),
        ),
        body: BlocConsumer<DisputeCubit, DisputeState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('dispute.submit_success'.tr())),
                );
                Navigator.pop(context);
              },
              error: (msg) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                    'dispute.reason_label'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _reason,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: _reasons.map((r) => DropdownMenuItem(
                      value: r['value'],
                      child: Text(r['label']!.tr()),
                    )).toList(),
                    onChanged: (v) => setState(() => _reason = v!),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'dispute.description_label'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'dispute.description_hint'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'dispute.evidence_label'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    'dispute.evidence_hint'.tr(),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _buildImageSelection(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text('dispute.submit'.tr()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSelection() {
    return Row(
      children: [
        ..._images.asMap().entries.map((entry) {
          final idx = entry.key;
          final file = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => setState(() => _images.removeAt(idx)),
                  ),
                ),
              ],
            ),
          );
        }),
        if (_images.length < 3)
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_a_photo, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_descriptionController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('dispute.description_required'.tr())),
      );
      return;
    }
    context.read<DisputeCubit>().submitDispute(
      orderId: widget.orderId,
      reason: _reason,
      description: _descriptionController.text.trim(),
      images: _images,
    );
  }
}
