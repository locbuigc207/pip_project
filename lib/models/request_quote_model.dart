class RequestQuoteModel {
  String? customerName;
  String? customerPhone;
  String? destination;
  String? member;
  String? pickupAddress;
  String? pickupTime;
  String? returnTime;

  RequestQuoteModel(
      {this.customerName,
        this.customerPhone,
        this.destination,
        this.member,
        this.pickupAddress,
        this.pickupTime,
        this.returnTime});

  RequestQuoteModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    destination = json['destination'];
    member = json['member'];
    pickupAddress = json['pickup_address'];
    pickupTime = json['pickup_time'];
    returnTime = json['return_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['destination'] = this.destination;
    data['member'] = this.member;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_time'] = this.pickupTime;
    data['return_time'] = this.returnTime;
    return data;
  }
}
