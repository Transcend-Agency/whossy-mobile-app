import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How big message text is in a chat. Medium is the default and matches the
/// size other messaging apps use for message text.
enum ChatTextSize {
  small('Small', 14),
  medium('Medium', 16),
  large('Large', 18);

  const ChatTextSize(this.label, this.fontSize);

  final String label;
  final double fontSize;
}

/// The chat text size chosen in Settings. It is a setting for this phone,
/// not the account, so it stays the same across sign-outs.
class ChatTextSizeNotifier extends ChangeNotifier {
  static const storageKey = 'chat_text_size';

  ChatTextSizeNotifier({
    Future<String?> Function(String key)? read,
    Future<void> Function(String key, String value)? write,
  })  : _read = read ?? SharedPreferencesAsync().getString,
        _write = write ?? SharedPreferencesAsync().setString {
    _restore();
  }

  final Future<String?> Function(String key) _read;
  final Future<void> Function(String key, String value) _write;

  ChatTextSize _size = ChatTextSize.medium;

  /// Set once someone has picked a size, so a slow read from storage does
  /// not overwrite it.
  bool _chosen = false;

  bool _disposed = false;

  ChatTextSize get size => _size;

  double get fontSize => _size.fontSize;

  Future<void> _restore() async {
    try {
      final stored = await _read(storageKey);
      final match = ChatTextSize.values.where((s) => s.name == stored);
      if (_disposed || _chosen || match.isEmpty || match.first == _size) {
        return;
      }
      _size = match.first;
      notifyListeners();
    } catch (e) {
      debugPrint('Could not read the chat text size: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> setSize(ChatTextSize size) async {
    _chosen = true;
    if (size == _size) return;
    _size = size;
    notifyListeners();
    try {
      await _write(storageKey, size.name);
    } catch (e) {
      debugPrint('Could not save the chat text size: $e');
    }
  }
}
