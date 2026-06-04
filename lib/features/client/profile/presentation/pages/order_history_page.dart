import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../cart/presentation/bloc/order_bloc.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderBloc>()..add(const LoadOrders()),
      child: Scaffold(
        appBar: AppBar(title: Text('order.history_title'.tr())),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (msg) => Center(
                    child: Text(msg, style: const TextStyle(color: Colors.red)),
                  ),
                  ordersLoaded: (orders) {
                    if (orders.isEmpty) {
                      return const Center(
                        child: Text("Vous n'avez passé aucune commande."),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.fastfood,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              "Commande #${order['id']?.toString().substring(0, 8) ?? 'Unknown'}",
                            ),
                            subtitle: Text(
                              "${order['total']} FCFA • ${order['status']}",
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              // Navigate to order details
                            },
                          ),
                        );
                      },
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
