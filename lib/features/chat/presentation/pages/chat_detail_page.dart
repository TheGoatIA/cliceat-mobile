import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../../data/models/chat_model.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatDetailPage extends StatefulWidget {
  final ConversationModel conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadMessages(widget.conversation);
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(widget.conversation.id, text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'chat.support'.tr();
    if (widget.conversation.type == 'restaurant') title = 'chat.restaurant'.tr();
    if (widget.conversation.type == 'delivery') title = 'chat.driver'.tr();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          title,
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primaryRed, strokeWidth: 2),
            ),
            messagesLoaded: (conv, messages) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderRole == 'client';

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.78,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? AppTheme.primaryRed : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft:
                                    Radius.circular(isMe ? 16 : 0),
                                bottomRight:
                                    Radius.circular(isMe ? 0 : 16),
                              ),
                              border: isMe
                                  ? null
                                  : Border.all(color: AppTheme.lineSoft),
                              boxShadow:
                                  isMe ? [] : AppTheme.shadowSm,
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.content,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isMe
                                        ? Colors.white
                                        : AppTheme.inkSoft,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeago.format(msg.createdAt,
                                      locale:
                                          context.locale.languageCode),
                                  style: GoogleFonts.inter(
                                    color: isMe
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : AppTheme.mutedLight,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildMessageInput(),
                ],
              );
            },
            error: (msg) => Center(
              child: Text(
                msg,
                style: GoogleFonts.inter(
                    color: AppTheme.primaryRed, fontSize: 14),
              ),
            ),
            orElse: () => const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primaryRed, strokeWidth: 2),
            ),
          );
        },
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
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppTheme.ink),
                  decoration: InputDecoration(
                    hintText: 'chat.type_message'.tr(),
                    hintStyle: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.mutedLight),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
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
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
