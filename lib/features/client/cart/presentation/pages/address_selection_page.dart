import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
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
            SnackBar(
              content: Text('address.location_denied'.tr()),
              backgroundColor: AppTheme.primaryRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
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
          SnackBar(
            content: Text('address.location_error'.tr()),
            backgroundColor: AppTheme.primaryRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _gpsLoading = false);
    }
  }

  void _showAddAddressSheet() {
    final labelCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'address.add_title'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.ink,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.line),
              ),
              child: TextField(
                controller: addressCtrl,
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
                decoration: InputDecoration(
                  labelText: 'address.address_hint'.tr(),
                  labelStyle:
                      GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: AppTheme.muted, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.line),
              ),
              child: TextField(
                controller: labelCtrl,
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
                decoration: InputDecoration(
                  labelText: 'address.label_hint'.tr(),
                  labelStyle:
                      GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
                  prefixIcon: const Icon(Icons.label_outline,
                      color: AppTheme.muted, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final address = addressCtrl.text.trim();
                  if (address.isEmpty) return;
                  Navigator.pop(ctx);
                  
                  double lat = 4.05;
                  double lng = 9.70;
                  try {
                    final permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      final pos = await Geolocator.getCurrentPosition(
                        locationSettings:
                            const LocationSettings(accuracy: LocationAccuracy.low),
                      ).timeout(const Duration(seconds: 2));
                      lat = pos.latitude;
                      lng = pos.longitude;
                    }
                  } catch (_) {}

                  try {
                    await getIt<UserRepository>().addAddress({
                      'address': address,
                      'label': labelCtrl.text.trim().isNotEmpty
                          ? labelCtrl.text.trim()
                          : 'Adresse',
                      'lat': lat,
                      'lng': lng,
                    });
                    await _loadAddresses();
                  } catch (_) {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'common.save'.tr(),
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          'address.select_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showAddAddressSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: AppTheme.primaryRed, size: 20),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primaryRed, strokeWidth: 2))
          : Column(
              children: [
                InkWell(
                  onTap: _gpsLoading ? null : _useCurrentLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: AppTheme.lineSoft)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.redSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _gpsLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.primaryRed),
                                  ))
                              : const Icon(Icons.my_location,
                                  color: AppTheme.primaryRed, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'address.use_current_location'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppTheme.bgWarm,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Icon(Icons.location_off_outlined,
                                    size: 36, color: AppTheme.muted),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'profile.no_addresses'.tr(),
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'address.add_first'.tr(),
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppTheme.muted),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: _showAddAddressSheet,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text('address.add_title'.tr()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryRed,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _addresses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final addr = _addresses[index];
                            return GestureDetector(
                              onTap: () => _selectAddress(addr),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: AppTheme.lineSoft),
                                  boxShadow: AppTheme.shadowSm,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppTheme.redSoft,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.location_on,
                                          color: AppTheme.primaryRed,
                                          size: 20),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            addr.label ?? addr.address,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: AppTheme.ink,
                                            ),
                                          ),
                                          if (addr.label != null)
                                            Text(
                                              addr.address,
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: AppTheme.muted),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded,
                                        color: AppTheme.mutedLight),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
