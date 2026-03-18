import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/features/client/cart/presentation/bloc/cart_cubit.dart';

/// Crée une base Drift en mémoire pour les tests.
AppDatabase _inMemoryDb() => AppDatabase.forTesting(
      drift.DatabaseConnection(NativeDatabase.memory()),
    );

void main() {
  late AppDatabase db;
  late CartCubit cubit;

  setUp(() {
    db = _inMemoryDb();
    cubit = CartCubit(db);
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  // ─── Ajout d'un item ──────────────────────────────────────────────────────

  group('addItem', () {
    test('ajoute un item — panier non vide', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.name, 'Ndolé');
      expect(cubit.state.itemCount, 1);
    });

    test('incrémente la quantité si même item ajouté deux fois', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );

      expect(cubit.state.items.length, 1);
      expect(cubit.state.itemCount, 2);
    });

    test('vide le panier et ajoute si restaurant différent', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      // Ajout depuis un autre restaurant → clear automatique
      await cubit.addItem(
        restaurantId: 'resto2',
        itemId: 'item2',
        name: 'Poulet braisé',
        price: 3000,
      );

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.restaurantId, 'resto2');
    });
  });

  // ─── Suppression ─────────────────────────────────────────────────────────

  group('removeItem', () {
    test('supprime un item — panier mis à jour', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      final id = cubit.state.items.first.id;
      await cubit.removeItem(id);

      expect(cubit.state.items, isEmpty);
    });
  });

  // ─── clearCart ────────────────────────────────────────────────────────────

  group('clearCart', () {
    test('vide le panier — état vide', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item2',
        name: 'Beignets',
        price: 500,
      );

      await cubit.clearCart();

      expect(cubit.state.items, isEmpty);
      expect(cubit.state.itemCount, 0);
      expect(cubit.state.subtotal, 0.0);
    });
  });

  // ─── subtotal ─────────────────────────────────────────────────────────────

  group('subtotal', () {
    test('calcule le sous-total correctement', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item2',
        name: 'Eau minérale',
        price: 300,
      );

      expect(cubit.state.subtotal, 2800.0);
    });
  });

  // ─── wouldClearCart ───────────────────────────────────────────────────────

  group('wouldClearCart', () {
    test('retourne false pour panier vide', () async {
      expect(cubit.state.wouldClearCart('resto1'), false);
    });

    test('retourne false pour même restaurant', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      expect(cubit.state.wouldClearCart('resto1'), false);
    });

    test('retourne true pour restaurant différent', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );
      expect(cubit.state.wouldClearCart('resto2'), true);
    });
  });

  // ─── Persistance Drift ────────────────────────────────────────────────────

  group('Persistance', () {
    test('les items sont rechargés depuis la base au redémarrage', () async {
      await cubit.addItem(
        restaurantId: 'resto1',
        itemId: 'item1',
        name: 'Ndolé',
        price: 2500,
      );

      // Simuler un redémarrage (nouvel instance Cubit, même DB)
      final cubit2 = CartCubit(db);
      await cubit2.loadCart();

      expect(cubit2.state.items.length, 1);
      expect(cubit2.state.items.first.name, 'Ndolé');

      await cubit2.close();
    });
  });
}
