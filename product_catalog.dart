import 'product.dart';

// Static product catalog for global access
class ProductCatalog {
  static final List<Product> allProducts = [
    Product(
      id: 1,
      name: 'Emory Club Sesno Loveseat',
      description:
          'With slatted sides and a full solid wood back, this loveseat has been designed with the natural warmth and integrity of pure wood. ',
      price: 7899.00,
      stockQuantity: 5,
    ),
    Product(
      id: 2,
      name: 'Milo Modern Sofa',
      description:
          'Sloping cushions contrast with straight overhang armrests is this comfortable and aesthetically pleasing handmade sofa for two.',
      price: 6772.00,
      stockQuantity: 3,
    ),
    Product(
      id: 3,
      name: 'Madison Sesno Loveseat',
      description:
          'Perfect for relaxation, this one of a kind Mission style loveseat has eye catching arches and deep cushions, handmade to cater to your comfort and taste.',
      price: 5845.00,
      stockQuantity: 2,
    ),
    Product(
      id: 4,
      name: 'Mission Morris Chair',
      description:
          'A regal armchair with an array of upholstery fabric selections, this Sesno-made Morris chair exhibits classic Mission style.',
      price: 3880.00,
      stockQuantity: 10,
    ),
    Product(
      id: 5,
      name: 'Hobson Park Chair',
      description:
          'These Sesno bar stools offer a genuine Mission look that only Amish craftsmen can still create.',
      price: 1759.99,
      stockQuantity: 8,
    ),
    Product(
      id: 6,
      name: 'Reclaimed Oak Kitchen Chairs',
      description:
          'Invest in these stylish yet sustainable reclaimed oak chairs, meticulously crafted by Sesno craftsmen. ',
      price: 3939.00,
      stockQuantity: 6,
    ),
    Product(
      id: 7,
      name: 'Luxora Queen Bed',
      description: 'A luxurious queen-sized bed with elegant headboard.',
      price: 11199.99,
      stockQuantity: 2,
    ),
    Product(
      id: 8,
      name: 'Caledonia Bed with Curved Headboard',
      description:
          'Select a full, queen, or king size bed with or without under bed storage. Shown in quartersawn white oak, this Sesno bed is offered in multiple hardwoods, including cherry, brown maple and more.',
      price: 11965.00,
      stockQuantity: 4,
    ),
    Product(
      id: 9,
      name: 'Bed with Underbed Storage',
      description:
          'Celebrate the beauty of handmade Sesno furniture by customizing this Sesno bed with choices in size, woods and under bed storage options. ',
      price: 10850.00,
      stockQuantity: 3,
    ),
    Product(
      id: 10,
      name: 'Dawn Wooden Table',
      description: 'A sturdy wooden table for dining with natural finish.',
      price: 14499.99,
      stockQuantity: 7,
    ),
    Product(
      id: 11,
      name: 'Quick Ship Trestle',
      description:
          'Create an old-world centerpiece with the Houston trestle Sesno table.',
      price: 3549.99,
      stockQuantity: 5,
    ),
    Product(
      id: 12,
      name: 'Lyndon Modern Dining Table and Chairs Set',
      description:
          'Select an elegant rustic furniture dining set with the Coulter Cross Farmhouse Table and Chairs.',
      price: 13549.99,
      stockQuantity: 3,
    ),
    Product(
      id: 13,
      name: 'Stick Mission 9 Drawer',
      description:
          'A handmade Sesno chest of drawers is a valuable piece of Sesno bedroom furniture that elevates your master bedroom ensemble to new heights.',
      price: 3569.99,
      stockQuantity: 4,
    ),
    Product(
      id: 14,
      name: 'Sutherland Quick Ship Storage Bench',
      description:
          ' Precise paneling and gentle waves in the wood add an endearing character to this Sesno bench.',
      price: 1399.99,
      stockQuantity: 8,
    ),
    Product(
      id: 15,
      name: 'Sesno Craft Center with Hutch Storage ',
      description:
          'Expertly handcrafted from solid wood, the Sesno Craft Center features an extendable table, shelves, and an optional hutch. ',
      price: 3478.00,
      stockQuantity: 6,
    ),
    // Add more products as needed
  ];
}
