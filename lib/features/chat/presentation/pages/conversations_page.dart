import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/chat_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/services/chat_service.dart';
import '../../../../core/network/socket_service.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(
        getIt<ChatService>(),
        getIt<SocketService>(),
      )..add(LoadConversations()),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatelessWidget {
  const _ConversationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return Badge(
                  label: Text('${state.unreadCount}'),
                  child: const Icon(Icons.notifications_outlined),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  TextButton(
                    onPressed: () =>
                        context.read<ChatBloc>().add(LoadConversations()),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 72, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('Aucune conversation',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Vos conversations apparaîtront ici.'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ChatBloc>().add(LoadConversations()),
            child: ListView.separated(
              itemCount: state.conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final conv =
                    state.conversations[i] as Map<String, dynamic>;
                final id = conv['_id'] as String? ?? '';
                final lastMsg =
                    conv['lastMessage'] as Map<String, dynamic>?;
                final participants =
                    (conv['participants'] as List?) ?? [];
                final other = participants.isNotEmpty
                    ? (participants.first as Map?)
                    : null;
                final name =
                    other?['name'] as String? ?? 'Conversation';
                final avatar =
                    other?['avatar'] as String?;
                final unread = conv['unreadCount'] as int? ?? 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        avatar != null ? NetworkImage(avatar) : null,
                    child:
                        avatar == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    lastMsg?['content'] as String? ?? 'Aucun message',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: unread > 0
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              theme.colorScheme.primary,
                          child: Text('$unread',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        )
                      : null,
                  onTap: () => context.push(
                      '/chat/$id',
                      extra: name),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
