import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:whossy_app/common/utils/index.dart';

part 'message.g.dart'; // Generated file for JSON serialization

@JsonSerializable()
class Message {
  final String id;

  @JsonKey(name: 'sender_id')
  final String senderId;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(
    name: 'timestamp',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? timestamp;

  @JsonKey(name: 'local_photo')
  final String? localPhoto;

  @JsonKey(name: 'photo')
  final String? photo;

  @JsonKey(name: 'status')
  final MessageStatus? status;

  Message({
    String? id,
    String? senderId,
    required this.message,
    this.timestamp,
    this.photo,
    this.localPhoto,
    this.status = MessageStatus.undelivered,
  })  : id = id ?? const Uuid().v4(),
        senderId = senderId ?? FirebaseAuth.instance.currentUser!.uid;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  // Manually added copyWith method
  Message copyWith({
    String? id,
    String? senderId,
    String? message,
    TimestampWrapper? timestamp,
    String? localPhoto,
    String? photo,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      localPhoto: localPhoto ?? this.localPhoto,
      photo: photo ?? this.photo,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''
Message {
  id: $id,
  senderId: $senderId,
  message: $message,
  timestamp: ${timestamp?.timestamp?.toDate().toString() ?? 'null'},
  localPhotos: $localPhoto ?? 'null'},
  photos: $photo ?? 'null'},
  status: $status
}''';
  }
}
