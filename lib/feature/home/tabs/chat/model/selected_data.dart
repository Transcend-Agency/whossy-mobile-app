import 'current_chat.dart';
import 'message.dart';

class SelectedData {
  final Stream<List<Message>> messagesStream;
  final CurrentChat? currentChat;

  SelectedData({
    required this.messagesStream,
    required this.currentChat,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    return other is SelectedData &&
        messagesStream == other.messagesStream &&
        currentChat == other.currentChat;
  }

  @override
  int get hashCode => messagesStream.hashCode ^ currentChat.hashCode;
}
