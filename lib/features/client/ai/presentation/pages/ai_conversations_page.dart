import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/ai_cubit.dart';
import 'ai_assistant_page.dart';

class AiConversationsPage extends StatefulWidget {
  const AiConversationsPage({super.key});

  @override
  State<AiConversationsPage> createState() => _AiConversationsPageState();
}

class _AiConversationsPageState extends State<AiConversationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AiCubit>().loadConversations();
  }

  void _openConversation(String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AiCubit>(),
          child: AiAssistantPage(conversationId: conversationId),
        ),
      ),
    ).then((_) => context.read<AiCubit>().loadConversations());
  }

  void _newConversation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AiCubit>(),
          child: const AiAssistantPage(),
        ),
      ),
    ).then((_) => context.read<AiCubit>().loadConversations());
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return DateFormat('HH:mm').format(date);
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return DateFormat('EEEE', 'fr').format(date);
    return DateFormat('dd/MM/yy').format(date);
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
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Assistant IA',
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppTheme.ink,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryRed),
            onPressed: _newConversation,
          ),
        ],
      ),
      body: BlocBuilder<AiCubit, AiState>(
        builder: (context, state) {
          final conversations = state.maybeWhen(
            conversationList: (convs) => convs,
            orElse: () => null,
          );

          if (conversations == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (conversations.isEmpty) {
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
                      child: const Icon(Icons.psychology_rounded, size: 40, color: AppTheme.primaryRed),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aucune conversation',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Posez vos questions à l\'assistant ClicEat',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _newConversation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Démarrer une conversation',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return Dismissible(
                key: Key(conv.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppTheme.primaryRed,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.archive_outlined, color: Colors.white),
                ),
                onDismissed: (_) => context.read<AiCubit>().archiveConversation(conv.id),
                child: ListTile(
                  onTap: () => _openConversation(conv.id),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.redSoft,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.psychology_rounded, color: AppTheme.primaryRed, size: 22),
                  ),
                  title: Text(
                    conv.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.ink,
                    ),
                  ),
                  subtitle: conv.lastMessagePreview.isNotEmpty
                      ? Text(
                          conv.lastMessagePreview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
                        )
                      : null,
                  trailing: Text(
                    _formatDate(conv.lastMessageAt),
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.mutedLight),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
