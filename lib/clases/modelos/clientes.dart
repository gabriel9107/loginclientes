class Cliente {
  Cliente({
    required this.city,
    required this.customerCode,
    required this.customerDir,
    required this.customerName,
    required this.id,
    required this.isDelete,
    required this.phone1,
    required this.shippingMth,
    required this.vendorCode,
  });

  String city;
  String customerCode;
  String customerDir;
  String customerName;
  int id;
  bool isDelete;
  String phone1;
  String shippingMth;
  String vendorCode;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        city: json["City"],
        customerCode: json["CustomerCode"],
        customerDir: json["CustomerDir"],
        customerName: json["CustomerName"],
        id: json["ID"],
        isDelete: json["IsDelete"],
        phone1: json["Phone1"],
        shippingMth: json["ShippingMth"],
        vendorCode: json["VendorCode"],
      );

  Map<String, dynamic> toJson() => {
        "City": city,
        "CustomerCode": customerCode,
        "CustomerDir": customerDir,
        "CustomerName": customerName,
        "ID": id,
        "IsDelete": isDelete,
        "Phone1": phone1,
        "ShippingMth": shippingMth,
        "VendorCode": vendorCode,
      };
}
