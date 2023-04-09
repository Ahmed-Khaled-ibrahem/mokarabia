import 'product.dart';

abstract class PaymentType {
  String paid = 'paid';
  String free = 'free';
}

class Order{
  late String personName;
  late Map<Product,int> products;
  late DateTime date;
  late String payment;

  Order({required this.personName, required this.products}){
    date = DateTime.now();
  }
}