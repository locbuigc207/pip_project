class GroupDetailModel {
  String? groupId;
  String? groupName;
  int? groupStep;
  int? groupStatus;
  List<ListMessage>? listMessage;

  GroupDetailModel(
      {this.groupId,
        this.groupName,
        this.groupStep,
        this.groupStatus,
        this.listMessage});

  GroupDetailModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupName = json['group_name'];
    groupStep = json['group_step'];
    groupStatus = json['group_status'];
    if (json['list_message'] != null) {
      listMessage = <ListMessage>[];
      json['list_message'].forEach((v) {
        listMessage!.add(new ListMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['group_step'] = this.groupStep;
    data['group_status'] = this.groupStatus;
    if (this.listMessage != null) {
      data['list_message'] = this.listMessage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMessage {
  String? id;
  String? groupId;
  int? sender;
  String? message;
  int? status;
  int? messStep;
  String? createdAt;

  ListMessage(
      {this.id,
        this.groupId,
        this.sender,
        this.message,
        this.status,
        this.messStep,
        this.createdAt});

  ListMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    sender = json['sender'];
    message = json['message'];
    status = json['status'];
    messStep = json['mess_step'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['status'] = this.status;
    data['mess_step'] = this.messStep;
    data['created_at'] = this.createdAt;
    return data;
  }
}
