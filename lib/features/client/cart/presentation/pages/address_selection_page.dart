import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/user_service.dart';

class AddressSelectionPage extends StatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  List<Map<String, dynamic>> _addresses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final res = await getIt<UserService>().getAddresses();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        setState(() {
          _addresses = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _selectAddress(Map<String, dynamic> address) {
    context.pop(address);
  }

  void _showAddAddressSheet() {
    final labelCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('address.add_title'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: addressCtrl,
              decoration: InputDecoration(
                labelText: 'address.address_hint'.tr(),
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: labelCtrl,
              decoration: InputDecoration(
                labelText: 'address.label_hint'.tr(),
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final address = addressCtrl.text.trim();
                  if (address.isEmpty) return;
                  Navigator.pop(ctx);
                  try {
                    await getIt<UserService>().addAddress({
                      'address': address,
                      if (labelCtrl.text.trim().isNotEmpty) 'label': labelCtrl.text.trim(),
                    });
                    setState(() => _loading = true);
                    await _loadAddresses();
                  } catch (_) {}
                },
                child: Text('common.save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('address.select_title'.tr()),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'address.add_title'.tr(),
            onPressed: _showAddAddressSheet,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text('profile.no_addresses'.tr(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _showAddAddressSheet,
                        icon: const Icon(Icons.add),
                        label: Text('address.add_title'.tr()),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final addr = _addresses[index];
                    final label = addr['label']?.toString();
                    final address = addr['address']?.toString() ?? '';
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.location_on,
                            color: theme.colorScheme.primary, size: 20),
                      ),
                      title: Text(label ?? address,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: label != null ? Text(address) : null,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectAddress(addr),
                    );
                  },
                ),
    );
  }
}
