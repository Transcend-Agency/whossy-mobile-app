import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:whossy_app/common/utils/index.dart';

part 'message.g.dart'; // Generated file for JSON serialization

@JsonSerializable()
class Message {
  final String id;

  @JsonKey(name: 'senderId')
  final String senderId;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(
    name: 'timestamp',
    fromJson: AppUtils.timestampFromJson,
    toJson: AppUtils.timestampToJson,
  )
  final Timestamp? timestamp;

  @JsonKey(name: 'local_photos')
  final List<String>? localPhotos;

  @JsonKey(name: 'photos')
  final List<String>? photos;

  @JsonKey(name: 'status')
  final MessageStatus? status;

  Message({
    String? id,
    String? senderId,
    required this.message,
    this.timestamp,
    this.photos,
    this.localPhotos,
    this.status = MessageStatus.undelivered,
  })  : id = id ?? const Uuid().v4(),
        senderId = senderId ?? FirebaseAuth.instance.currentUser!.uid;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return '''
Message {
  id: $id,
  senderId: $senderId,
  message: $message,
  timestamp: ${timestamp?.toDate().toString() ?? 'null'},
  localPhotos: ${localPhotos?.join(', ') ?? 'null'},
  photos: ${photos?.join(', ') ?? 'null'},
  status: $status
}''';
  }
}
