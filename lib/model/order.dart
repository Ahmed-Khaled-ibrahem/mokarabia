import 'product.dart';

abstract class PaymentType {
  static String paid = 'paid';
  static String free = 'free';
}

class Order{
  late String personName;
  late Map<String,int> products;
  late DateTime date;
  late String payment;

  Order({required this.personName, required this.products, required this.payment}){
    date = DateTime.now();
  }

  Map<String,dynamic> export(){
    return {
      "person":personName,
      "orderdate":date.toString(),
      "payment":payment,
      "cap":products[Product.cappuccino],
      "latte":products[Product.latte],
      "esp":products[Product.espresso],
    };
  }
}