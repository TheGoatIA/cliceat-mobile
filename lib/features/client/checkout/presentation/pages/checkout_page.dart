import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/network/services/order_service.dart';
import '../../../../../../core/network/services/user_profile_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<dynamic> _addresses = [];
  String? _selectedAddressId;
  String _paymentMethod = 'mobile_money';
  bool _loading = false;
  bool _loadingAddresses = true;

  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    try {
      final resp =
          await getIt<UserProfileService>().getAddresses();
      if (resp.isSuccessful) {
        final data = resp.body as Map<String, dynamic>;
        setState(() {
          _addresses =
              (data['data'] as List?) ?? [];
          if (_addresses.isNotEmpty) {
            _selectedAddressId =
                _addresses.first['_id'] as String?;
          }
        });
      }
    } catch (_) {}
    setState(() => _loadingAddresses = false);
  }

  Future<void> _placeOrder(BuildContext context) async {
    final cart = context.read<CartBloc>().state;
    if (cart.isEmpty) return;

    setState(() => _loading = true);
    try {
      final items = cart.items
          .map((i) => {
                'item': i.itemId,
                'quantity': i.quantity,
                'price': i.price,
              })
          .toList();

      final body = {
        'restaurant': cart.restaurantId,
        'items': items,
        'deliveryAddress': _selectedAddressId != null
            ? {'addressId': _selectedAddressId}
            : {'address': _addressCtrl.text.trim()},
        'paymentMethod': _paymentMethod,
        if (_noteCtrl.text.isNotEmpty) 'note': _noteCtrl.text.trim(),
        if (cart.couponCode != null) 'couponCode': cart.couponCode,
      };

      final resp = await getIt<OrderService>().createOrder(body);
      if (resp.isSuccessful && context.mounted) {
        final data = resp.body as Map<String, dynamic>;
        final orderId = (data['data'] as Map?)?['_id'] as String? ?? '';
        final paymentUrl =
            (data['data'] as Map?)?['paymentUrl'] as String?;

        context.read<CartBloc>().add(ClearCart());

        if (_paymentMethod == 'mobile_money' &&
            paymentUrl != null &&
            context.mounted) {
          context.push('/payment',
              extra: {'url': paymentUrl, 'orderId': orderId});
        } else if (context.mounted) {
          context.go('/tracking/$orderId');
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de la commande. Réessayez.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur réseau. Vérifiez votre connexion.')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartBloc>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Finaliser la commande')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery address
          Text('Adresse de livraison',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_loadingAddresses)
            const Center(child: CircularProgressIndicator())
          else if (_addresses.isNotEmpty)
            ...(_addresses.map((addr) {
              final id = addr['_id'] as String? ?? '';
              final label = addr['label'] as String? ?? 'Adresse';
              final full = addr['address'] as String? ?? '';
              return RadioListTile<String>(
                value: id,
                groupValue: _selectedAddressId,
                onChanged: (v) =>
                    setState(() => _selectedAddressId = v),
                title: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                subtitle: Text(full),
              );
            }))
          else
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Entrez votre adresse de livraison',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

          const SizedBox(height: 20),

          // Payment method
          Text('Mode de paiement',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'mobile_money',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v!),
                  title: const Text('Mobile Money'),
                  subtitle: const Text(
                      'Orange Money, MTN MoMo, Wave'),
                  secondary: const Icon(Icons.phone_android),
                ),
                RadioListTile<String>(
                  value: 'wallet',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v!),
                  title: const Text('Portefeuille ClicEat'),
                  secondary: const Icon(Icons.account_balance_wallet),
                ),
                RadioListTile<String>(
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v!),
                  title: const Text('Paiement à la livraison'),
                  secondary: const Icon(Icons.payments),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Note
          Text('Instructions spéciales',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(
              hintText: 'Sans piment, bien cuit...',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 20),

          // Summary
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sous-total'),
                      Text('${cart.subtotal.toStringAsFixed(0)} XAF'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Livraison'),
                      Text('${cart.deliveryFee.toStringAsFixed(0)} XAF'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text('${cart.total.toStringAsFixed(0)} XAF',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _loading ? null : () => _placeOrder(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: _loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Confirmer la commande · ${cart.total.toStringAsFixed(0)} XAF',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}
