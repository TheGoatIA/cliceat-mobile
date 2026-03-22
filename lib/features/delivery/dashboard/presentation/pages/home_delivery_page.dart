import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeDeliveryPage extends StatefulWidget {
  const HomeDeliveryPage({super.key});

  @override
  State<HomeDeliveryPage> createState() => _HomeDeliveryPageState();
}

class _HomeDeliveryPageState extends State<HomeDeliveryPage> {
  bool isOnline = false;
  final Logger _logger = Logger();

  EarningsModel? _earnings;
  bool _earningsLoading = true;

  StreamSubscription<Position>? _locationSubscription;
  late final MissionBloc _missionBloc;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _missionBloc = getIt<MissionBloc>()
      ..add(const MissionEvent.loadActiveMissions());
    _wsSubscription = getIt<WebSocketService>().missionEvents.listen((_) {
      _missionBloc.add(const MissionEvent.loadActiveMissions());
    });
    _loadEarnings();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _missionBloc.close();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadEarnings() async {
    setState(() => _earningsLoading = true);
    final result = await getIt<DriverRepository>().getEarnings();
    if (!mounted) return;
    result.fold(
      (err) {
        _logger.e('Failed to load earnings: ${err.message}');
        setState(() => _earningsLoading = false);
      },
      (earnings) => setState(() {
        _earnings = earnings;
        _earningsLoading = false;
      }),
    );
  }

  Future<void> _startLocationUpdates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _logger.w('Location permission denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('delivery.location_permission_required'.tr())),
        );
      }
      return;
    }

    final LocationSettings settings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = _androidLocationSettings;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = _appleLocationSettings;
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      );
    }

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: settings).listen((
          position,
        ) {
          getIt<DriverRepository>().updateLocation(
            position.latitude,
            position.longitude,
          );
          getIt<WebSocketService>().emitLocationUpdate(
            position.latitude,
            position.longitude,
          );
        }, onError: (e) => _logger.w('GPS stream error: $e'));
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.dashboard_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOnlineToggle(theme),
            const SizedBox(height: 24),
            _buildStatusCard(theme),
            const SizedBox(height: 24),
            _buildTodayStats(theme),
            const SizedBox(height: 24),
            _buildRecentDeliveries(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statut', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? 'delivery.online'.tr() : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isOnline ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: isOnline,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
            activeColor: theme.colorScheme.primary,
            onChanged: (value) {
              setState(() {
                isOnline = value;
                // TODO: Dispatch event to bloc to trigger GPS Background Service
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 110,
      decoration: BoxDecoration(
        color: isOnline
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline ? Icons.radar : Icons.power_settings_new,
              size: 48,
              color: isOnline ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              isOnline
                  ? 'delivery.waiting_mission'.tr()
                  : 'Vous êtes hors ligne',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isOnline ? theme.colorScheme.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'delivery.todays_earnings'.tr(),
            value: _earningsLoading
                ? '...'
                : '${(_earnings?.today ?? 0).toStringAsFixed(0)} FCFA',
            icon: Icons.account_balance_wallet,
            color: theme.colorScheme.secondary,
            isLoading: _earningsLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'delivery.deliveries'.tr(),
            value: _earningsLoading
                ? '...'
                : '${_earnings?.todayDeliveries ?? 0}',
            icon: Icons.delivery_dining,
            color: theme.colorScheme.primary,
            isLoading: _earningsLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsAndRecent(ThemeData theme) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        final missions = state.maybeWhen(
          loaded: (m) => m,
          orElse: () => <Map<String, dynamic>>[],
        );
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        final pendingMissions = missions.where((m) {
          final status = m['status'] as String? ?? '';
          return status == 'pending' || status == 'assigned';
        }).toList();

        final recentOrders = (_earnings?.dailyBreakdown ?? []).isEmpty
            ? <Map<String, dynamic>>[]
            : <Map<String, dynamic>>[];

        return ListView(
          children: [
            if (pendingMissions.isNotEmpty) ...[
              Text(
                'delivery.active_missions'.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...pendingMissions.map(
                (m) => _buildMissionCard(context, m, theme),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'delivery.recent_deliveries'.tr(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (recentOrders.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'delivery.no_history'.tr(),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              ...recentOrders.map((o) => _buildRecentOrderTile(o, theme)),
          ],
        );
      },
    );
  }

  // ─── Navigation (turn-by-turn via external maps app) ──────────────────────

  Future<void> _navigateTo(double lat, double lng, String label) async {
    final encoded = Uri.encodeComponent(label);
    // Try Google Maps first, then fallback to geo: URI
    final gmapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($encoded)');
    if (await canLaunchUrl(gmapsUri)) {
      await launchUrl(gmapsUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }
  }

  // ─── Photo proof of delivery ──────────────────────────────────────────────

  Future<String?> _pickDeliveryPhoto() async {
    final picker = ImagePicker();
    final choice = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('delivery.photo_proof_take'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('delivery.photo_proof_gallery'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return null;
    final file = await picker.pickImage(source: choice, imageQuality: 70);
    return file?.path;
  }

  // ─── Cash confirmation code ───────────────────────────────────────────────

  Future<String?> _askCashCode() async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('delivery.cash_code_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('delivery.cash_code_message'.tr()),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'delivery.cash_code_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text('delivery.cash_code_confirm'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDeliveries(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dernières livraisons', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: const Text('Commande #10842'),
              subtitle: const Text('Livré à 14:30 • Akwa'),
              trailing: Text(
                '+1500 FCFA',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
