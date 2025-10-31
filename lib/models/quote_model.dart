class QuoteModel {
  String? message;
  QuoteData? data;

  QuoteModel({this.message, this.data});

  QuoteModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new QuoteData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class QuoteData {
  String? code;
  String? member;
  String? pickupTime;
  String? pickupAddress;
  String? destination;
  String? returnTime;
  String? customerName;
  String? customerPhone;
  int? status;
  Null? cskhId;
  Null? cskhName;
  Null? cost;
  String? createdAt;
  String? updatedAt;
  String? sId;
  int? iV;
  String? link;
  String? id;

  QuoteData(
      {this.code,
        this.member,
        this.pickupTime,
        this.pickupAddress,
        this.destination,
        this.returnTime,
        this.customerName,
        this.customerPhone,
        this.status,
        this.cskhId,
        this.cskhName,
        this.cost,
        this.createdAt,
        this.updatedAt,
        this.sId,
        this.iV,
        this.link,
        this.id});

  QuoteData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    member = json['member'];
    pickupTime = json['pickup_time'];
    pickupAddress = json['pickup_address'];
    destination = json['destination'];
    returnTime = json['return_time'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    status = json['status'];
    cskhId = json['cskh_id'];
    cskhName = json['cskh_name'];
    cost = json['cost'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sId = json['_id'];
    iV = json['__v'];
    link = json['link'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['member'] = this.member;
    data['pickup_time'] = this.pickupTime;
    data['pickup_address'] = this.pickupAddress;
    data['destination'] = this.destination;
    data['return_time'] = this.returnTime;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['status'] = this.status;
    data['cskh_id'] = this.cskhId;
    data['cskh_name'] = this.cskhName;
    data['cost'] = this.cost;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['link'] = this.link;
    data['id'] = this.id;
    return data;
  }
}
