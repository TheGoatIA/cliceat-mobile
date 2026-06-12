import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/ai_cubit.dart';

class GastroGuidePage extends StatefulWidget {
  const GastroGuidePage({super.key});

  @override
  State<GastroGuidePage> createState() => _GastroGuidePageState();
}

class _GastroGuidePageState extends State<GastroGuidePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _dotController;

  static const _suggestedQuestions = [
    "Qu'est-ce que le Ndolé?",
    'Recette du Poulet DG',
    'Spécialités de Douala',
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    context.read<AiCubit>().initGastroGuide();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? overrideText]) {
    final text = overrideText ?? _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<AiCubit>().sendGastroMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ai.gastro_title'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: AppTheme.ink,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            Text(
              'ai.gastro_subtitle'.tr(),
              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.muted),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AiCubit, AiState>(
        listener: (context, state) {
          state.maybeWhen(
            gastroChat: (history, isTyping) {
              if (history.isNotEmpty || isTyping) _scrollToBottom();
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            gastroChat: (history, isTyping) => Column(
              children: [
                // Suggested questions (only at start)
                if (history.isEmpty) _buildSuggestedQuestions(),
                Expanded(
                  child: history.isEmpty && !isTyping
                      ? _buildWelcome()
                      : _buildMessageList(history, isTyping),
                ),
                _buildInput(),
              ],
            ),
            orElse: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryRed),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestedQuestions.length,
        separatorBuilder: (_, _x) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => _sendMessage(_suggestedQuestions[i]),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.line),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Text(
                _suggestedQuestions[i],
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.ink),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 36,
                color: AppTheme.primaryRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenue !\nExplorez la gastronomie camerounaise',
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Posez vos questions sur les plats, recettes\net spécialités du Cameroun.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.muted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<Map<String, dynamic>> history, bool isTyping) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: history.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (isTyping && index == history.length) {
          return _buildTypingIndicator();
        }
        final msg = history[index];
        final isUser = msg['role'] == 'user';
        return _buildBubble(
          isUser: isUser,
          content: msg['content'] as String? ?? '',
        );
      },
    );
  }

  Widget _buildBubble({required bool isUser, required String content}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryRed : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          border: isUser ? null : Border.all(color: AppTheme.lineSoft),
          boxShadow: isUser ? [] : AppTheme.shadowSm,
        ),
        child: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isUser ? Colors.white : AppTheme.inkSoft,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: AppTheme.lineSoft),
        ),
        child: AnimatedBuilder(
          animation: _dotController,
          builder: (_, _a) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final offset = ((_dotController.value + i * 0.33) % 1.0);
                final opacity = offset < 0.5
                    ? 0.3 + offset * 1.4
                    : 0.3 + (1 - offset) * 1.4;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: opacity.clamp(0.3, 1.0),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppTheme.mutedLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.lineSoft)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
                  decoration: InputDecoration(
                    hintText: 'ai.gastro_hint'.tr(),
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.mutedLight,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _sendMessage();
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
