// ChatType _stringToEnum(String chatTypeString) {
//   return ChatType.values.firstWhere((e) => e.toString() == chatTypeString);
// }

ChatType _stringToEnum(String? chatTypeString) {
  switch (chatTypeString) {
    case 'text':
      return ChatType.text;
    case 'image':
      return ChatType.image;
    case 'video':
      return ChatType.video;
    case 'doc':
      return ChatType.doc;
    case 'audio':
      return ChatType.audio;
    case 'delete':
      return ChatType.delete;
    case 'camera':
      return ChatType.camera;
    case 'gallery':
      return ChatType.gallery;

    default:
      return ChatType.none;
  }
}

class ChatModel {
  ChatModel({
    this.id,
    required this.chatTitle,
    required this.time,
    required this.chatType,
    this.isRead,
    this.sendBy,
    this.isDelete,
  });

  String? id;
  String chatTitle;
  String? time;
  String? isRead;
  ChatType? chatType;
  String? sendBy;
  String? isDelete;

  copyWith({
    String? id,
    String? chatTitle,
    String? time,
    ChatType? chatType,
    String? readStatus,
    String? sendBy,
    String? isDelete,
  }) {
    return ChatModel(
      id: id ?? this.id,
      chatTitle: chatTitle ?? this.chatTitle,
      time: time ?? this.time,
      chatType: chatType ?? this.chatType,
      sendBy: sendBy ?? this.sendBy,
      isDelete: isDelete ?? this.isDelete,
    );
  }

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatModel(
      id: json['id'] as String?,
      chatTitle: json['chatTitle'] as String,
      time: json['time'] as String?,
      chatType: _stringToEnum(json['chatType'] as String?),
      isRead: json['readStatus'] as String?,
      sendBy: json['sendBy'] as String?,
      isDelete: json['isDelete'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatTitle': chatTitle,
      'time': time,
      'chatType': chatType?.name,
      'readStatus': isRead,
      'sendBy': sendBy,
      'isDelete': isDelete,
    };
  }
}

enum ChatType { none, text, image, audio, video, doc, delete, camera, gallery }
