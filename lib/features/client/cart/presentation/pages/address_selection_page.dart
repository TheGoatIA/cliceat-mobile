import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cliceat_app/di/injection.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';

class AddressSelectionPage extends StatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  List<AddressModel> _addresses = [];
  bool _loading = true;
  bool _gpsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _loading = true);
    final result = await getIt<UserRepository>().getAddresses();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (addresses) => setState(() {
        _addresses = addresses;
        _loading = false;
      }),
    );
  }

  void _selectAddress(AddressModel address) {
    context.pop({
      'address': address.address,
      'label': address.label,
      'lat': address.lat,
      'lng': address.lng,
    });
  }

  /// Gets the user's current GPS position and returns it as an address.
  Future<void> _useCurrentLocation() async {
    setState(() => _gpsLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('address.location_denied'.tr())),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (mounted) {
        final address = {
          'address': 'address.current_location'.tr(),
          'label': 'address.current_location'.tr(),
          'lat': position.latitude,
          'lng': position.longitude,
        };
        context.pop(address);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('address.location_error'.tr())),
        );
      }
    } finally {
      if (mounted) setState(() => _gpsLoading = false);
    }
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
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('address.add_title'.tr(),
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: addressCtrl,
              decoration: InputDecoration(
                labelText: 'address.address_hint'.tr(),
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: labelCtrl,
              decoration: InputDecoration(
                labelText: 'address.label_hint'.tr(),
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
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
                    await getIt<UserRepository>().addAddress({
                      'address': address,
                      if (labelCtrl.text.trim().isNotEmpty)
                        'label': labelCtrl.text.trim(),
                    });
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
          : Column(
              children: [
                // "Use current location" button at top
                InkWell(
                  onTap: _gpsLoading ? null : _useCurrentLocation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _gpsLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ))
                              : Icon(Icons.my_location,
                                  color: theme.colorScheme.primary,
                                  size: 20),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'address.use_current_location'.tr(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_off_outlined,
                                  size: 64,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.4)),
                              const SizedBox(height: 16),
                              Text('profile.no_addresses'.tr(),
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(
                                          color: theme.colorScheme
                                              .onSurfaceVariant)),
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
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final addr = _addresses[index];
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.location_on,
                                    color: theme.colorScheme.primary,
                                    size: 20),
                              ),
                              title: Text(addr.label ?? addr.address,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: addr.label != null
                                  ? Text(addr.address)
                                  : null,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _selectAddress(addr),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
