import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
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
      context.read<ChatCubit>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            tooltip: 'chat.support'.tr(),
            onPressed: () {
              context.read<ChatCubit>().createSupportConversation();
            },
          )
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          state.maybeWhen(
            messagesLoaded: (conversation, _) {
              // Navigate to detail automatically when a new conversation is created via support button
              context.push('/client/chat/${conversation.id}', extra: conversation);
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            conversationsLoaded: (conversations, unreadCount) {
              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Text('chat.empty'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.read<ChatCubit>().createSupportConversation(),
                        icon: const Icon(Icons.support_agent),
                        label: Text('chat.contact_support'.tr()),
                      )
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  final isUnread = conv.unreadCount > 0;
                  
                  Widget icon;
                  String title;
                  if (conv.type == 'restaurant') {
                    icon = const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.restaurant, color: Colors.white));
                    title = 'chat.restaurant'.tr();
                  } else if (conv.type == 'delivery') {
                    icon = const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.two_wheeler, color: Colors.white));
                    title = 'chat.driver'.tr();
                  } else {
                    icon = const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.support_agent, color: Colors.white));
                    title = 'chat.support'.tr();
                  }

                  return ListTile(
                    leading: icon,
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
                    ),
                    subtitle: Text(
                      conv.lastMessage?.content ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: isUnread ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeago.format(conv.updatedAt, locale: context.locale.languageCode),
                          style: TextStyle(color: isUnread ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                        ),
                        if (isUnread)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                            child: Text(
                              conv.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          )
                      ],
                    ),
                    onTap: () {
                      context.push('/client/chat/${conv.id}', extra: conv);
                    },
                  );
                },
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
