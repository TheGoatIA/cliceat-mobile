import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class _OnboardingSlide {
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final List<Color> gradient;
  final Color accentColor;

  const _OnboardingSlide({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _bgAnim;
  late final Animation<double> _bgScale;

  static const _slides = [
    _OnboardingSlide(
      titleKey: 'onboarding.slide1_title',
      subtitleKey: 'onboarding.slide1_subtitle',
      icon: Icons.restaurant_menu_rounded,
      gradient: [Color(0xFFCC0000), Color(0xFFE53935)],
      accentColor: Color(0xFFCC0000),
    ),
    _OnboardingSlide(
      titleKey: 'onboarding.slide2_title',
      subtitleKey: 'onboarding.slide2_subtitle',
      icon: Icons.delivery_dining_rounded,
      gradient: [Color(0xFFF5A623), Color(0xFFFB8C00)],
      accentColor: Color(0xFFF5A623),
    ),
    _OnboardingSlide(
      titleKey: 'onboarding.slide3_title',
      subtitleKey: 'onboarding.slide3_subtitle',
      icon: Icons.stars_rounded,
      gradient: [Color(0xFF1565C0), Color(0xFF1976D2)],
      accentColor: Color(0xFF1565C0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bgAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _bgScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _bgAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgAnim.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.selectionClick();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final slide = _slides[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              slide.gradient[0],
              slide.gradient[1],
              slide.gradient[0].withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              if (_currentPage < _slides.length - 1)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _pageController.jumpToPage(_slides.length - 1);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.8),
                      ),
                      child: Text('onboarding.skip'.tr()),
                    ),
                  ),
                )
              else
                const SizedBox(height: 44),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _slides.length,
                  itemBuilder: (_, i) =>
                      _buildSlide(context, _slides[i], size),
                ),
              ),

              // Bottom section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    // Page dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _currentPage < _slides.length - 1
                          ? _buildNextButton()
                          : _buildFinalButtons(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(
      BuildContext context, _OnboardingSlide slide, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration animée
        AnimatedBuilder(
          animation: _bgScale,
          builder: (_, child) => Transform.scale(
            scale: _bgAnim.status == AnimationStatus.completed ||
                    _bgAnim.status == AnimationStatus.forward
                ? _bgScale.value
                : _bgScale.value,
            child: child,
          ),
          child: Container(
            width: size.width * 0.55,
            height: size.width * 0.55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: size.width * 0.42,
                height: size.width * 0.42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  slide.icon,
                  size: size.width * 0.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),

        // Texte
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                slide.titleKey.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                slide.subtitleKey.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      key: const ValueKey('next'),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _slides[_currentPage].accentColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'onboarding.next'.tr(),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalButtons(BuildContext context) {
    return Column(
      key: const ValueKey('final'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            context.push('/auth/login?mode=client');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _slides.last.accentColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(
            'onboarding.btn_client'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            context.push('/auth/login?mode=delivery');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          icon: const Icon(Icons.delivery_dining_outlined, size: 20),
          label: Text(
            'onboarding.btn_delivery'.tr(),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
