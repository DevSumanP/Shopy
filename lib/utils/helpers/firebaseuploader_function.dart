import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/banner_model.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/shop/models/product_attribute_model.dart';
import '../../features/shop/models/product_model.dart';
import '../../features/shop/models/product_variation_model.dart';
import '../../routes/routes.dart';

class FirebaseUploader {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Category data
  final List<Map<String, dynamic>> categories = [
    {
      "id": "1",
      "image": Images.sportIcon, // Path to image in assets
      "name": "Sports",
      "isFeatured": true,
    },
    {
      "id": "5",
      "image": Images.furnitureIcon,
      "name": "Furniture",
      "isFeatured": true,
    },
    {
      "id": "2",
      "image": Images.electronicsIcon,
      "name": "Electronics",
      "isFeatured": true,
    },
    {
      "id": "3",
      "image": Images.clothIcon,
      "name": "Clothes",
      "isFeatured": true,
    },
    {
      "id": "4",
      "image": Images.animalIcon,
      "name": "Animals",
      "isFeatured": true,
    },
    {
      "id": "6",
      "image": Images.shoeIcon,
      "name": "Shoes",
      "isFeatured": true,
    },
    {
      "id": "7",
      "image": Images.cosmeticsIcon,
      "name": "Cosmetics",
      "isFeatured": true,
    },
    {
      "id": "14",
      "image": Images.jeweleryIcon,
      "name": "Jewelery",
      "isFeatured": true,
    },

    //subcategories - sports
    {
      "id": "8",
      "image": Images.sportIcon,
      "name": "Sport Shoes",
      "isFeatured": false,
      'parentId': '1',
    },
    {
      "id": "9",
      "image": Images.sportIcon,
      "name": "Track suits",
      "isFeatured": false,
      'parentId': '1',
    },
    {
      "id": "10",
      "image": Images.sportIcon,
      "name": "Sports Equipments",
      "isFeatured": false,
      'parentId': '1',
    },
    //subcategories -funiture
    {
      "id": "11",
      "image": Images.furnitureIcon,
      "name": "Bedroom furniture",
      "isFeatured": false,
      'parentId': '5',
    },
    {
      "id": "12",
      "image": Images.furnitureIcon,
      "name": "Kitchen furniture",
      "isFeatured": false,
      'parentId': '5',
    },
    {
      "id": "13",
      "image": Images.furnitureIcon,
      "name": "Office furniture",
      "isFeatured": false,
      'parentId': '5',
    },

    //subcategories - electronics
    {
      "id": "14",
      "image": Images.electronicsIcon,
      "name": "Laptop",
      "isFeatured": false,
      'parentId': '2',
    },
    {
      "id": "15",
      "image": Images.electronicsIcon,
      "name": "Mobile",
      "isFeatured": false,
      'parentId': '2',
    },

    // Subcategories - cloth
    {
      "id": "16",
      "image": Images.clothIcon,
      "name": "Shirts",
      "isFeatured": false,
      'parentId': '3',
    },
  ];

  // Method to upload images and category data
  Future<void> uploadCategoryData() async {
    try {
      for (var category in categories) {
        // Upload the image to Firebase Storage and get the download URL
        String imageUrl =
            await uploadImageToStorage(category['image'], category['id']);

        // Add the category data to Firestore
        Map<String, dynamic> categoryData = {
          "id": category["id"],
          "image": imageUrl, // Save the image URL
          "name": category["name"],
          "isFeatured": category["isFeatured"],
          if (category.containsKey("parentId"))
            "parentId": category["parentId"],
        };

        await firestore
            .collection('Categories')
            .doc(category["id"])
            .set(categoryData);
        print("Uploaded category: ${category['name']}");
      }
      print("All categories uploaded successfully.");
    } catch (e) {
      print("Error uploading categories: $e");
    }
  }

  // Method to upload a single image to Firebase Storage
  Future<String> uploadImageToStorage(String assetPath, String id) async {
    try {
      // Load the image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$id.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Upload the file to Firebase Storage
      Reference ref = storage.ref().child('categories/$id.png');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded for $id: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  // Banner data
  final List<BannerModel> banners = [
    BannerModel(
        targetScreen: Routes.order, active: false, imageUrl: Images.banner1),
    BannerModel(
        targetScreen: Routes.cart, active: true, imageUrl: Images.banner2),
    BannerModel(
        targetScreen: Routes.favourites,
        active: true,
        imageUrl: Images.banner3),
    BannerModel(
        targetScreen: Routes.search, active: true, imageUrl: Images.banner4),
    BannerModel(
        targetScreen: Routes.settings, active: true, imageUrl: Images.banner5),
    BannerModel(
        targetScreen: Routes.userAddress,
        active: true,
        imageUrl: Images.banner6),
    BannerModel(
        targetScreen: Routes.checkout, active: false, imageUrl: Images.banner8),
  ];

// Method to upload banners and banner data
  Future<void> uploadBannerData() async {
    try {
      for (var banner in banners) {
        // Upload the image to Firebase Storage and get the download URL
        String imageUrl = await uploadBannerImageToStorage(
            banner.imageUrl, banner.targetScreen);

        // Add the banner data to Firestore
        Map<String, dynamic> bannerData = {
          "targetScreen": banner.targetScreen,
          "image": imageUrl, // Save the image URL
          "active": banner.active,
        };

        await firestore
            .collection('Banners')
            .doc(banner.imageUrl
                .split('/')
                .last) // Use the image name as the document ID
            .set(bannerData);
        print("Uploaded banner with image: ${banner.imageUrl}");
      }
      print("All banners uploaded successfully.");
    } catch (e) {
      print("Error uploading banners: $e");
    }
  }

// Method to upload a single banner image to Firebase Storage
  Future<String> uploadBannerImageToStorage(
      String assetPath, String targetScreen) async {
    try {
      // Load the image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/${targetScreen}_banner.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Upload the file to Firebase Storage
      Reference ref = storage.ref().child('banners/${targetScreen}_banner.png');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Banner image uploaded for $targetScreen: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading banner image: $e");
      return "";
    }
  }

  final List<BrandModel> brands = [
    BrandModel(
        id: '1',
        image: Images.nikeLogo,
        name: 'Nike',
        isFeatured: true,
        productsCount: 265),
    BrandModel(
        id: '2',
        image: Images.acerlogo,
        name: 'Acer',
        isFeatured: false,
        productsCount: 36),
    BrandModel(
        id: '3',
        image: Images.adidasLogo,
        name: 'Adidas',
        isFeatured: true,
        productsCount: 95),
    BrandModel(
        id: '4',
        image: Images.jordanLogo,
        name: 'Jordan',
        isFeatured: true,
        productsCount: 36),
    BrandModel(
        id: '5',
        image: Images.pumaLogo,
        name: 'Puma',
        isFeatured: true,
        productsCount: 65),
    BrandModel(
        id: '6',
        image: Images.appleLogo,
        name: 'Apple',
        isFeatured: false,
        productsCount: 16),
    BrandModel(
        id: '7',
        image: Images.zaraLogo,
        name: 'ZARA',
        isFeatured: false,
        productsCount: 36),
    BrandModel(
        id: '8',
        image: Images.electronicsIcon,
        name: 'Samsung',
        isFeatured: false,
        productsCount: 36),
    BrandModel(
        id: '9',
        image: Images.kenwoodLogo,
        name: 'Kenwood',
        isFeatured: false,
        productsCount: 36),
    BrandModel(
        id: '10',
        image: Images.ikeaLogo,
        name: 'IKEA',
        isFeatured: false,
        productsCount: 36),
  ];

// Method to upload brand data
  Future<void> uploadBrandData() async {
    try {
      for (var brand in brands) {
        // Upload the image to Firebase Storage and get the download URL
        String imageUrl =
            await uploadBrandImageToStorage(brand.image, brand.name);

        // Prepare the brand data for Firestore
        Map<String, dynamic> brandData = {
          "id": brand.id,
          "name": brand.name,
          "isFeatured": brand.isFeatured,
          "productsCount": brand.productsCount,
          "imageUrl": imageUrl, // Save the image URL
        };

        // Save the brand data in Firestore
        await firestore.collection('Brands').doc(brand.id).set(brandData);
        print("Uploaded brand: ${brand.name}");
      }
      print("All brands uploaded successfully.");
    } catch (e) {
      print("Error uploading brands: $e");
    }
  }

// Method to upload a single brand image to Firebase Storage
  Future<String> uploadBrandImageToStorage(
      String assetPath, String brandName) async {
    try {
      // Load the image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$brandName.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Upload the file to Firebase Storage
      Reference ref = storage.ref().child('brands/$brandName.png');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Brand image uploaded for $brandName: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading brand image: $e");
      return "";
    }
  }

  /// List of all Products
  static final List<ProductModel> products = [
    ProductModel(
      id: '001',
      title: 'Green Nike sports shoe',
      stock: 15,
      price: 135,
      isFeatured: true,
      thumbnail: Images.productImage1,
      description: 'Green Nike sports shoe',
      brand: BrandModel(
        id: '1',
        image: Images.nikeLogo,
        name: 'Nike',
        productsCount: 265,
        isFeatured: true,
      ),
      images: [
        Images.productImage1,
        Images.productImage23,
        Images.productImage21,
        Images.productImage9
      ],
      salePrice: 30,
      sku: 'ABR4568',
      categoryId: '1',
      productAttributes: [
        ProductAttributeModel(name: 'Color', values: ['Green', 'Black', 'Red']),
        ProductAttributeModel(
            name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
      ],
      productVariations: [
        ProductVariationModel(
          id: '1',
          stock: 34,
          price: 134,
          salePrice: 122.6,
          image: Images.productImage1,
          description:
              'This is a Product description for Green Nike sports shoe.',
          attributeValues: {'Color': 'Green', 'Size': 'EU 34'},
        ),
      ],
      productType: 'ProductType.variable',
    ),
    ProductModel(
      id: '002',
      title: 'Blue T-shirt for all ages',
      stock: 15,
      price: 35,
      isFeatured: true,
      thumbnail: Images.productImage69,
      description:
          'This is a Product description for Blue Nike Sleeve less vest.',
      brand: BrandModel(
        id: '6',
        image: Images.zaraLogo,
        name: 'ZARA',
      ),
      images: [
        Images.productImage68,
        Images.productImage69,
        Images.productImage5
      ],
      salePrice: 30,
      sku: 'ABR4568',
      categoryId: '16',
      productAttributes: [
        ProductAttributeModel(name: 'Size', values: ['EU34', 'EU32']),
        ProductAttributeModel(name: 'Color', values: ['Green', 'Red', 'Blue']),
      ],
      productType: 'ProductType.single',
      productVariations: [],
    ),
    ProductModel(
      id: '003',
      title: 'Leather brown Jacket',
      stock: 15,
      price: 38000,
      isFeatured: false,
      thumbnail: Images.productImage64,
      description: 'This is a Product description for Leather brown Jacket.',
      brand: BrandModel(
        id: '6',
        image: Images.zaraLogo,
        name: 'ZARA',
      ),
      images: [
        Images.productImage64,
        Images.productImage65,
        Images.productImage66,
        Images.productImage67
      ],
      salePrice: 30,
      sku: 'ABR4568',
      categoryId: '16',
      productAttributes: [
        ProductAttributeModel(name: 'Size', values: ['EU34', 'EU32']),
        ProductAttributeModel(name: 'Color', values: ['Green', 'Red', 'Blue']),
      ],
      productType: 'ProductType.single',
      productVariations: [],
    ),
    ProductModel(
      id: '004',
      title: '4 Color collar t-shirt dry fit',
      stock: 15,
      price: 135,
      isFeatured: false,
      thumbnail: Images.productImage60,
      description:
          'This is a Product description for 4 Color collar t-shirt dry fit.',
      brand: BrandModel(
        id: '6',
        image: Images.zaraLogo,
        name: 'ZARA',
      ),
      images: [
        Images.productImage60,
        Images.productImage61,
        Images.productImage62,
        Images.productImage63
      ],
      salePrice: 30,
      sku: 'ABR4568',
      categoryId: '16',
      productAttributes: [
        ProductAttributeModel(
            name: 'Color', values: ['Red', 'Yellow', 'Green', 'Blue']),
        ProductAttributeModel(
            name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
      ],
      productVariations: [
        ProductVariationModel(
          id: '1',
          stock: 34,
          price: 134,
          salePrice: 122.6,
          image: Images.productImage60,
          description:
              'This is a Product description for 4 Color collar t-shirt dry fit',
          attributeValues: {'Color': 'Red', 'Size': 'EU 34'},
        ),
        ProductVariationModel(
          id: '2',
          stock: 15,
          price: 132,
          image: Images.productImage68,
          attributeValues: {'Color': 'Red', 'Size': 'EU 32'},
        ),
        ProductVariationModel(
          id: '3',
          stock: 0,
          price: 234,
          image: Images.productImage61,
          attributeValues: {'Color': 'Yellow', 'Size': 'EU 34'},
        ),
        ProductVariationModel(
          id: '4',
          stock: 222,
          price: 232,
          image: Images.productImage61,
          attributeValues: {'Color': 'Yellow', 'Size': 'EU 32'},
        ),
        ProductVariationModel(
          id: '5',
          stock: 0,
          price: 334,
          image: Images.productImage62,
          attributeValues: {'Color': 'Green', 'Size': 'EU 34'},
        ),
        ProductVariationModel(
          id: '6',
          stock: 11,
          price: 332,
          image: Images.productImage62,
          attributeValues: {'Color': 'Green', 'Size': 'EU 30'},
        ),
        ProductVariationModel(
          id: '7',
          stock: 0,
          price: 334,
          image: Images.productImage63,
          attributeValues: {'Color': 'Blue', 'Size': 'EU 30'},
        ),
        ProductVariationModel(
          id: '8',
          stock: 11,
          price: 332,
          image: Images.productImage63,
          attributeValues: {'Color': 'Blue', 'Size': 'EU 34'},
        ),
      ],
      productType: 'ProductType.variable',
    ),
    ProductModel(
      id: '005',
      title: 'Nike Air Jordon Shoes',
      stock: 15,
      price: 35,
      isFeatured: false,
      thumbnail: Images.productImage10,
      description:
          'Nike Air Jordon Shoes for running. Quality product, Long Lasting',
      brand: BrandModel(
        id: '1',
        image: Images.nikeLogo,
        name: 'Nike',
        productsCount: 265,
        isFeatured: true,
      ),
      images: [
        Images.productImage7,
        Images.productImage8,
        Images.productImage9,
        Images.productImage10
      ],
      salePrice: 30,
      sku: 'ABR4568',
      categoryId: '8',
      productAttributes: [
        ProductAttributeModel(
            name: 'Color', values: ['Orange', 'Black', 'Brown']),
        ProductAttributeModel(
            name: 'Size', values: ['EU 30', 'EU 32', 'EU 34']),
      ],
      productVariations: [
        ProductVariationModel(
          id: '1',
          stock: 16,
          price: 36,
          salePrice: 12.6,
          image: Images.productImage8,
          description:
              'Flutter is Google\'s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the uni',
          attributeValues: {'Color': 'Orange', 'Size': 'EU 34'},
        ),
      ],
      productType: 'ProductType.variable',
    ),
    ProductModel(
      id: '006',
      title: 'SAMSUNG Galaxy S9 (Pink, 64 GB) (4 GB RAM)',
      stock: 15,
      price: 750,
      isFeatured: false,
      thumbnail: Images.productImage11,
      description:
          'SAMSUNG Galaxy S9 (Pink, 64 GB) (4 GB RAM), Long Battery timing',
      brand: BrandModel(
        id: '7',
        image: Images.appleLogo,
        name: 'Samsung',
      ),
      images: [
        Images.productImage11,
        Images.productImage12,
        Images.productImage13,
        Images.productImage12
      ],
      salePrice: 650,
      sku: 'ABR4568',
      categoryId: '2',
      productAttributes: [
        ProductAttributeModel(name: 'Size', values: ['EU34', 'EU32']),
        ProductAttributeModel(name: 'Color', values: ['Green', 'Red', 'Blue']),
      ],
      productType: 'ProductType.single',
      productVariations: [],
    ),
    ProductModel(
      id: '007',
      title: 'TOMI Dog food',
      stock: 15,
      price: 20,
      isFeatured: false,
      thumbnail: Images.productImage18,
      description:
          'This is a Product description for TOMI Dog food. There are more things that can be added but I am just practicing and nothing else.',
      brand: BrandModel(
        id: '7',
        image: Images.appleLogo,
        name: 'Tomi',
      ),
      salePrice: 10,
      sku: 'ABR4568',
      categoryId: '4',
      productAttributes: [
        ProductAttributeModel(name: 'Size', values: ['EU34', 'EU32']),
        ProductAttributeModel(name: 'Color', values: ['Green', 'Red', 'Blue']),
      ],
      productType: 'ProductType.single',
      images: [],
      productVariations: [],
    ),
    ProductModel(
      id: '008',
      title: 'Nike Air Jordon 19 Blue',
      stock: 15,
      price: 400,
      isFeatured: false,
      thumbnail: Images.productImage19,
      description:
          'This is a Product description for Nike Air Jordon. There are more things that can be added but I am just practicing and nothing else.',
      brand: BrandModel(
        id: '1',
        image: Images.nikeLogo,
        name: 'Nike',
      ),
      images: [
        Images.productImage19,
        Images.productImage20,
        Images.productImage21,
        Images.productImage22
      ],
      salePrice: 200,
      sku: 'ABR4568',
      categoryId: '8',
      productAttributes: [
        ProductAttributeModel(name: 'Size', values: ['EU34', 'EU32']),
        ProductAttributeModel(name: 'Color', values: ['Green', 'Red', 'Blue']),
      ],
      productType: 'ProductType.single',
      productVariations: [],
    ),
  ];

// Method to upload product data
  Future<void> uploadProductData() async {
    try {
      for (var product in products) {
        // Upload the product images to Firebase Storage and get the download URLs
        List<String> imageUrls = [];
        for (var image in product.images) {
          String imageUrl =
              await uploadProductImageToStorage(image, product.id);
          imageUrls.add(imageUrl);
        }

        // Prepare product data for Firestore
        Map<String, dynamic> productData = {
          'id': product.id,
          'title': product.title,
          'stock': product.stock,
          'price': product.price,
          'isFeatured': product.isFeatured,
          'thumbnail': imageUrls.isNotEmpty ? imageUrls[0] : null,
          'description': product.description,
          'brand': {
            'id': product.brand.id,
            'image': product.brand.image,
            'name': product.brand.name,
            'productsCount': product.brand.productsCount,
            'isFeatured': product.brand.isFeatured,
          },
          'images': imageUrls,
          'salePrice': product.salePrice,
          'sku': product.sku,
          'categoryId': product.categoryId,
          'productAttributes': product.productAttributes
              .map((attr) => {
                    'name': attr.name,
                    'values': attr.values,
                  })
              .toList(),
          'productVariations': product.productVariations
              .map((variation) => {
                    'id': variation.id,
                    'stock': variation.stock,
                    'price': variation.price,
                    'salePrice': variation.salePrice,
                    'image': variation.image,
                    'description': variation.description,
                    'attributeValues': variation.attributeValues,
                  })
              .toList(),
          'productType': product.productType,
        };

        // Upload product data to Firestore
        await FirebaseFirestore.instance
            .collection('products')
            .doc(product.id)
            .set(productData);

        print('Product ${product.title} uploaded successfully!');
      }
    } catch (e) {
      print('Error uploading product data: $e');
    }
  }

// Helper method to upload product images to Firebase Storage
  Future<String> uploadProductImageToStorage(
      String assetPath, String productId) async {
    try {
      // Load the image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      String fileName = assetPath.split('/').last;
      File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Define the storage path
      Reference storageRef =
          FirebaseStorage.instance.ref().child('products/$productId/$fileName');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }
}
