# ClicEat — Assets Images à générer

Toutes les images ci-dessous doivent être placées dans `assets/images/`.
L'app fonctionne sans elles (fallbacks intégrés), mais les pages seront visuellement complètes une fois qu'elles seront présentes.

---

## 1. `restaurant_placeholder.jpg`
**Dimensions:** 800 × 400 px
**Format:** JPEG (qualité 85%)
**Description:** Photo générique d'un restaurant camerounais. Intérieur chaleureux, lumières douces, tables bien dressées. Ambiance africaine moderne. Couleurs dominantes : orange, bois, vert. Pas de texte sur l'image.
**Utilisation:** Fallback affiché quand un restaurant n'a pas de photo de couverture.

---

## 2. `banner_promo.jpg`
**Dimensions:** 900 × 360 px
**Format:** JPEG (qualité 90%)
**Description:** Bannière promotionnelle. Fond sombre/dégradé. Au premier plan, une assiette appétissante de plat camerounais (ex: Ndolé, poulet DG, eru). Texte de type "Livraison Gratuite" visible en haut à gauche — grand, blanc, gras. Style photo-réaliste, lumineux.
**Utilisation:** Carrousel promo sur la page d'accueil quand l'API ne retourne pas de bannières.

---

## 3. `empty_cart.png`
**Dimensions:** 400 × 400 px
**Format:** PNG (fond transparent)
**Description:** Illustration flat design d'un panier vide souriant, style moderne africain. Couleurs : orange principal (#FF6B35), blanc. Lignes épurées. Peut inclure quelques petits éléments alimentaires autour (feuilles, points décoratifs).
**Utilisation:** Page panier vide.

---

## 4. `empty_orders.png`
**Dimensions:** 400 × 400 px
**Format:** PNG (fond transparent)
**Description:** Illustration flat design d'une personne assise qui attend, style minimaliste. À côté d'elle, une grande horloge ou un document vide. Couleurs neutres : gris clair, bleu doux. Ambiance "pas encore de commande".
**Utilisation:** Page historique des commandes (aucune commande).

---

## 5. `delivery_dashboard.png`
**Dimensions:** 500 × 350 px
**Format:** PNG (fond transparent)
**Description:** Illustration d'un livreur à moto, vue de profil, style flat/cartoon africain. Il porte un casque, un sac de livraison dans le dos. Couleurs vives : orange, vert. Style dynamique, en mouvement.
**Utilisation:** Écran d'accueil livreur quand il est hors-ligne (état vide).

---

## 6. `onboarding_1.png`
**Dimensions:** 600 × 500 px
**Format:** PNG (fond transparent)
**Description:** Illustration d'un téléphone avec une app de commande de nourriture à l'écran. Autour du téléphone, flottent des emojis d'aliments (🍗🥘🍕🌮). Style flat design coloré, ambiance joyeuse. Dominante orange.
**Utilisation:** Slide 1 de l'onboarding — "Commandez facilement".

---

## 7. `onboarding_2.png`
**Dimensions:** 600 × 500 px
**Format:** PNG (fond transparent)
**Description:** Illustration d'un livreur à moto qui apporte un sac de nourriture à un immeuble. Ville africaine en arrière-plan (immeubles colorés, palmiers). Flèche de trajectoire dessinée. Style flat coloré.
**Utilisation:** Slide 2 de l'onboarding — "Livraison rapide".

---

## 8. `onboarding_3.png`
**Dimensions:** 600 × 500 px
**Format:** PNG (fond transparent)
**Description:** Illustration d'un téléphone affichant une carte GPS avec un point de livraison. Icône de localisation animée/visible. Fond simple avec cercles concentriques qui émanent du point de livraison. Style flat, couleurs de l'app.
**Utilisation:** Slide 3 de l'onboarding — "Suivez en temps réel".

---

## Note technique

Les images sont déclarées dans `pubspec.yaml` sous `assets/images/`.
L'app utilisera des fallbacks icônes (pas de crash) si les fichiers sont absents au lancement.
Pour générer avec IA : Midjourney, DALL·E 3, ou Adobe Firefly sont recommandés.
Taille totale cible pour les 8 images : < 3 Mo.
