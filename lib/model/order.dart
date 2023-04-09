import 'product.dart';

abstract class PaymentType {
  static String paid = 'paid';
  static String free = 'free';
}

class Order{
  late String personName;
  late Map<Product,int> products;
  late DateTime date;
  late String payment;

  Order({required this.personName, required this.products, required this.payment}){
    date = DateTime.now();
  }

  Map<String,dynamic> export(){
    // return {
    //   "personName":personName,
    //   "date":date.toString(),
    //   "payment":payment,
    //
    //   "cap":products[allProducts[0]],
    //   "latte":products[allProducts[2]],
    //   "esp":products[allProducts[1]],
    // }
    return {
      "personname":"personName",
    "date":"date.toString()",
    "payment":"payment",

    "cap":5,
    "latte":6,
    "esp":1,
  };
  }
}