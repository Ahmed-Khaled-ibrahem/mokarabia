
class Product{
   String? image;
   double? price;
   int? id;
   String? name;

   static String cappuccino =  'Cappuccino';
   static String espresso =  'Espresso';
   static String latte =  'Latte';

  Product({this.id,this.name,this.price,this.image});
}

final List<Product> allProducts = [
Product(id: 0,name: 'Cappuccino',price: 25,image: 'assets/images/cap.jpg'),
Product(id: 1,name: 'Espresso',price: 20,image: 'assets/images/esp.jpg'),
Product(id: 2,name: 'Latte',price: 17,image: 'assets/images/late.jpg')
];

final Map<String, Product> allProductsMap = {
   'cap':Product(id: 0, name: 'Cappuccino', price: 25, image: 'assets/images/cap.jpg'),
   'esp':Product(id: 1, name: 'Espresso', price: 20, image: 'assets/images/esp.jpg'),
   'latte':Product(id: 2, name: 'Latte', price: 17, image: 'assets/images/late.jpg')
};

