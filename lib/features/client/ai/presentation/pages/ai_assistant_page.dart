import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/ai_state.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<AiCubit>().sendMessage(text);
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
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'ai.assistant_title'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppTheme.ink,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AiCubit, AiState>(
        listener: (context, state) {
          if (state == const AiState.typing() ||
              state.maybeWhen(idle: (_) => true, orElse: () => false)) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final messages = state.maybeWhen(
            idle: (msgs) => msgs,
            orElse: () => [],
          );

          final isTyping = state == const AiState.typing();

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty && !isTyping
                    ? _buildWelcomeState()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length + (isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (isTyping && index == 0) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border.all(color: AppTheme.lineSoft),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildDot(0),
                                    const SizedBox(width: 4),
                                    _buildDot(1),
                                    const SizedBox(width: 4),
                                    _buildDot(2),
                                  ],
                                ),
                              ),
                            );
                          }

                          final msgIndex = isTyping ? index - 1 : index;
                          final msg = messages[messages.length - 1 - msgIndex];
                          final isUser = msg.role == 'user';

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.78,
                              ),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? AppTheme.primaryRed
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                                  bottomRight: Radius.circular(isUser ? 0 : 16),
                                ),
                                border: isUser
                                    ? null
                                    : Border.all(color: AppTheme.lineSoft),
                                boxShadow: isUser ? [] : AppTheme.shadowSm,
                              ),
                              child: Text(
                                msg.content,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isUser
                                      ? Colors.white
                                      : AppTheme.inkSoft,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (state.maybeWhen(error: (e) => true, orElse: () => false))
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.redSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.maybeWhen(error: (e) => e, orElse: () => ''),
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryRed,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              _buildMessageInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                size: 40,
                color: AppTheme.primaryRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bonjour ! Je suis\nton assistant ClicEat',
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pose-moi une question sur les restaurants,\ntes commandes ou les livraisons.',
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

  Widget _buildDot(int index) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: AppTheme.mutedLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMessageInput() {
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
                    hintText: 'ai.ask_hint'.tr(),
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
              onTap: _sendMessage,
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
