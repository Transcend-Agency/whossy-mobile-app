import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../tabs/chat/data/state/chat_text_size_notifier.dart';

/// Settings row that shows the chat text size and opens a picker for it.
class ChatTextSizeTile extends StatelessWidget {
  const ChatTextSizeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.select<ChatTextSizeNotifier, ChatTextSize>(
      (n) => n.size,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: pagePadding,
          child: PreferenceTile(
            text: 'Chat Text Size',
            trailing: size.label,
            showDivider: false,
            onTap: () => showChatTextSizeSheet(context),
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}

Future<void> showChatTextSizeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    clipBehavior: Clip.hardEdge,
    shape: roundedTop,
    builder: (_) => const ChatTextSizeSheet(),
  );
}

/// Lets someone pick Small, Medium or Large and see sample messages at that
/// size straight away. The choice is saved as soon as it is tapped.
class ChatTextSizeSheet extends StatelessWidget {
  const ChatTextSizeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ChatTextSizeNotifier>();
    final style = TextStyles.messageText(notifier.fontSize);

    return AppSheetScaffold(
      topPadding: 16,
      title: 'Chat Text Size',
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SampleBubble(
              text: 'Hey! How has your week been?',
              isSender: false,
              style: style,
            ),
            addHeight(6),
            _SampleBubble(
              text: 'Pretty good, thanks. Coffee this weekend?',
              isSender: true,
              style: style,
            ),
            addHeight(20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: ChatTextSize.values.map((size) {
                return PreferenceChip<ChatTextSize>(
                  key: ValueKey('chat_text_size_${size.name}'),
                  value: size,
                  groupValue: notifier.size,
                  onChanged: (value) {
                    if (value != null) notifier.setSize(value);
                  },
                  title: size.label,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleBubble extends StatelessWidget {
  const _SampleBubble({
    required this.text,
    required this.isSender,
    required this.style,
  });

  final String text;
  final bool isSender;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .75,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: bubbleDecoration(isSender, false, false),
        child: Text(text, style: style),
      ),
    );
  }
}
