
class Product{
   String? image;
   double? price;
   int? id;
   String? name;

  Product({this.id,this.name,this.price,this.image});
}

List<Product> allProducts = [
Product(id: 0,name: 'Cappuccino',price: 20,image: 'assets/images/cap.jpg'),
Product(id: 1,name: 'Espresso',price: 20,image: 'assets/images/esp.jpg'),
Product(id: 2,name: 'Latte',price: 20,image: 'assets/images/late.jpg')
];
