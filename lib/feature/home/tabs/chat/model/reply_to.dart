import 'package:json_annotation/json_annotation.dart';

part 'reply_to.g.dart';

/// The message a reply answers, copied onto the reply when it is sent so the
/// quote shows without loading the original. Older app builds ignore it and
/// show the reply as a plain message.
@JsonSerializable()
class ReplyTo {
  /// Longest quote kept. The bubble shows two lines of it.
  static const maxTextLength = 200;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'sender_id')
  final String senderId;

  /// The quoted message's text, cut to [maxTextLength]. Null for a photo
  /// sent without text.
  @JsonKey(name: 'message', includeIfNull: false)
  final String? message;

  @JsonKey(name: 'has_photo')
  final bool hasPhoto;

  const ReplyTo({
    required this.id,
    required this.senderId,
    this.message,
    this.hasPhoto = false,
  });

  /// Builds the quote for a message being replied to.
  factory ReplyTo.quoting({
    required String id,
    required String senderId,
    String? message,
    String? photo,
    String? localPhoto,
  }) {
    final text = message?.trim();
    return ReplyTo(
      id: id,
      senderId: senderId,
      message: text == null || text.isEmpty
          ? null
          : text.length > maxTextLength
              ? '${text.substring(0, maxTextLength)}…'
              : text,
      hasPhoto: (photo?.isNotEmpty ?? false) ||
          (localPhoto?.isNotEmpty ?? false),
    );
  }

  /// One-line summary for the quote and the reply bar.
  String get preview => message ?? (hasPhoto ? '📷 Photo' : 'Message');

  factory ReplyTo.fromJson(Map<String, dynamic> json) =>
      _$ReplyToFromJson(json);

  /// Reads a reply quote, or null when it is missing or malformed, so one
  /// bad quote can't stop the rest of the chat from loading.
  static ReplyTo? tryFromJson(Object? json) {
    if (json is! Map) return null;
    try {
      return ReplyTo.fromJson(Map<String, dynamic>.from(json));
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => _$ReplyToToJson(this);
}
