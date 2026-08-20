class GardenChatRequestModel {
  String? message;
  String? imageBase64;

  GardenChatRequestModel({this.message, this.imageBase64});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null && message!.trim().isNotEmpty) {
      data['message'] = message!.trim();
    }
    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      data['image_base64'] = imageBase64;
    }
    return data;
  }
}
