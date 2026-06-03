import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().initGlobalChatListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'chat.title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          state.maybeWhen(
            messagesLoaded: (conversation, _) async {
              await context.push(
                '/client/chat/${conversation.id}',
                extra: conversation,
              );
              if (context.mounted) {
                context.read<ChatCubit>().loadConversations();
              }
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg.tr()),
                  backgroundColor: AppTheme.primaryRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            ),
            conversationsLoaded: (conversations, unreadCount) {
              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.bgWarm,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          size: 36,
                          color: AppTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'chat.empty'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => context
                              .read<ChatCubit>()
                              .createSupportConversation(),
                          icon: const Icon(Icons.support_agent, size: 18),
                          label: Text('chat.contact_support'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: conversations.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  final isUnread = conv.unreadCount > 0;

                  Color iconBg;
                  Color iconColor;
                  IconData iconData;
                  String title;

                  if (conv.type == 'restaurant') {
                    iconBg = AppTheme.honeySoft;
                    iconColor = AppTheme.honey;
                    iconData = Icons.restaurant;
                    title = 'chat.restaurant'.tr();
                  } else if (conv.type == 'delivery') {
                    iconBg = AppTheme.redSoft;
                    iconColor = AppTheme.primaryRed;
                    iconData = Icons.two_wheeler;
                    title = 'chat.driver'.tr();
                  } else {
                    iconBg = AppTheme.greenSoft;
                    iconColor = AppTheme.green;
                    iconData = Icons.support_agent;
                    title = 'chat.support'.tr();
                  }

                  return GestureDetector(
                    onTap: () async {
                      await context.push(
                        '/client/chat/${conv.id}',
                        extra: conv,
                      );
                      if (context.mounted) {
                        context.read<ChatCubit>().loadConversations();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUnread
                              ? AppTheme.primaryRed.withValues(alpha: 0.3)
                              : AppTheme.lineSoft,
                        ),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(iconData, color: iconColor, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.inter(
                                    fontWeight: isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 14,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  conv.lastMessage?.content ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: isUnread
                                        ? AppTheme.inkSoft
                                        : AppTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeago.format(
                                  conv.updatedAt,
                                  locale: context.locale.languageCode,
                                ),
                                style: GoogleFonts.inter(
                                  color: isUnread
                                      ? AppTheme.primaryRed
                                      : AppTheme.mutedLight,
                                  fontSize: 11,
                                  fontWeight: isUnread
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (isUnread) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      conv.unreadCount.toString(),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            orElse: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.read<ChatCubit>().createSupportConversation();
        },
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
    );
  }
}
