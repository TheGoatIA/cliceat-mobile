import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/driver_service.dart';
import 'package:chopper/chopper.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.nav_earnings'.tr()),
        elevation: 0,
      ),
      body: FutureBuilder<Response<Map<String, dynamic>>>(
        future: getIt<DriverService>().getMyEarnings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || (snapshot.data?.body == null)) {
            return const Center(child: Text("Erreur de chargement des gains ou données introuvables."));
          }
          
          final data = snapshot.data!.body!;
          final currentBalance = data['balance']?.toString() ?? '0';
          final totalTrips = data['totalTrips']?.toString() ?? '0';
          final totalTips = data['totalTips']?.toString() ?? '0';
          final history = data['history'] as List<dynamic>? ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceCard(context, currentBalance, totalTrips, totalTips),
                const SizedBox(height: 24),
                Text(
                  'Historique récent',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: Text("Aucun historique disponible.")),
                  ),
                ...history.map((e) => _buildEarningItem(
                  context, 
                  e['date']?.toString() ?? 'Date Inconnue', 
                  '${e['amount'] ?? 0} FCFA', 
                  '${e['trips'] ?? 0} courses', 
                  true
                )),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, String balance, String trips, String tips) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'Solde disponible',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8), fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '$balance FCFA',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(context, 'Courses', trips),
              Container(width: 1, height: 40, color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2)),
              _buildStat(context, 'Pourboires', '$tips F'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8), fontSize: 14)),
      ],
    );
  }

  Widget _buildEarningItem(BuildContext context, String date, String amount, String trips, bool highlight) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: highlight ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: highlight ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(Icons.monetization_on, color: highlight ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(trips),
        trailing: Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlight ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
