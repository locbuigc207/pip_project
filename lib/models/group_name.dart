class GroupNameModel {
  String? groupId;
  String? groupName;
  int? groupStep;
  int? groupStatus;

  GroupNameModel({this.groupId, this.groupName, this.groupStep, this.groupStatus});

  GroupNameModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupName = json['group_name'];
    groupStep = json['group_step'];
    groupStatus = json['group_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['group_step'] = this.groupStep;
    data['group_status'] = this.groupStatus;
    return data;
  }
}
