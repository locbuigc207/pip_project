class SendMessageModel {
  String? groupid;
  String? message;
  int? step;
  int? sender;

  SendMessageModel({this.groupid, this.message, this.step, this.sender});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    groupid = json['groupid'];
    message = json['message'];
    step = json['step'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupid'] = this.groupid;
    data['message'] = this.message;
    data['step'] = this.step;
    data['sender'] = this.sender;
    return data;
  }
}
