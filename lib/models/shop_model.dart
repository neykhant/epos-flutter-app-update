class ShopModel {
  final int id;
  final String shopName;
  final String address;
  final int employees;
  final String? phoneNoOne;
  final String? phoneNoTwo;
  ShopModel({
    required this.id,
    required this.shopName,
    required this.address,
    required this.employees,
    this.phoneNoOne,
    this.phoneNoTwo,
  });
}
