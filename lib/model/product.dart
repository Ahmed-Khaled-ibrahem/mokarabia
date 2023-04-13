
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

List<Product> allProducts = [
Product(id: 0,name: 'Cappuccino',price: 500,image: 'assets/images/cap.jpg'),
Product(id: 1,name: 'Espresso',price: 200,image: 'assets/images/esp.jpg'),
Product(id: 2,name: 'Latte',price: 300,image: 'assets/images/late.jpg')
];

Map<String, Product> allProductsMap = {
   'cap':Product(id: 0, name: 'Cappuccino', price: 500, image: 'assets/images/cap.jpg'),
   'esp':Product(id: 1, name: 'Espresso', price: 200, image: 'assets/images/esp.jpg'),
   'latte':Product(id: 2, name: 'Latte', price: 300, image: 'assets/images/late.jpg')
};

