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
      "cost":getCost().round(),
    };
  }

  double getCost(){

   double val =
       products[allProducts[0].name]! * allProducts[0].price!+
       products[allProducts[1].name]! * allProducts[1].price!+
       products[allProducts[2].name]! * allProducts[2].price!;
    return val;
  }
}