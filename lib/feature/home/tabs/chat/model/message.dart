import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

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
    fromJson: _timestampFromJson,
    toJson: _timestampToJson,
  )
  final Timestamp? timestamp;

  // Constructor with auto-generated id and current timestamp
  Message({
    String? id,
    String? senderId,
    required this.message,
    this.timestamp,
  })  : id = id ?? const Uuid().v4(),
        senderId = senderId ?? FirebaseAuth.instance.currentUser!.uid;

  // Factory constructor for creating a new Message instance from a map
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  // Method to convert Message instance to a map
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  // Helper methods for converting Timestamp from and to JSON
  static Timestamp? _timestampFromJson(dynamic json) => json as Timestamp?;
  static dynamic _timestampToJson(Timestamp? timestamp) => timestamp;
}
