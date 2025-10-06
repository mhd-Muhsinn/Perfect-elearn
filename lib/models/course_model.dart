// course_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';


class Course {
  final String id;
  final String name;
  final String price;
  final String thumbnail;
  final String description;
  final String category;
  final String subCategory;
  final String subSubCategories;
  final String language;
  final String courseType;
  final List<Map<String, dynamic>> videos; // new field for videos

  Course(
      {required this.id,
      required this.name,
      required this.price,
      required this.thumbnail,
      required this.description,
      required this.videos,
      required this.category,
      required this.subCategory,
      required this.subSubCategories,
      required this.language,
      required this.courseType});

  /// Load from doc snapshot **without videos** (useful for listing)
  factory Course.fromDocument(DocumentSnapshot doc) {
    return Course(
      id: doc.id,
      name: doc['name'] ?? '',
      price: (doc['price'] != null) ? doc['price'].toString() : '',
      thumbnail: doc['thumbnailUrl'] ?? '',
      description: doc['description'] ?? '',
      category: doc['category'] ?? '',
      subCategory: doc['subcategory'] ?? '',
      subSubCategories: doc['sub_subcategories'] ?? '',
      language: doc['language'] ?? '',
      courseType: doc['coureType'] ?? '',
      videos: [],
    );
  }

  /// Load with videos from subcollection in one go
  static Future<Course> fromDocumentWithVideos(DocumentSnapshot doc) async {
    try {
      // Fetch videos subcollection safely
      final videosSnapshot = await doc.reference.collection('videos').get();
      print(videosSnapshot);
      final videosList = videosSnapshot.docs.map((v) {
        return {
          'videoDocId': v.id,
          'title': v.data()['title'] ?? '',
          'description': v.data()['description'] ?? '',
          'video_url': v.data()['video_url'] ?? '',
          'public_id': v.data()['public_id'] ?? '',
          'format': v.data()['format'] ?? '',
          'duration': v.data()['duration'] ?? '',
          'created_at': v.data()['created_at'] ?? '',
        };
      }).toList();

      return Course(
        id: doc.id,
        name: doc['name'] ?? '',
        price: (doc['price'] != null) ? doc['price'].toString() : '',
        thumbnail: doc['thumbnailUrl'] ?? '',
        description: doc['description'] ?? '',
        videos: videosList,
        category: doc['category'] ?? '',
        subCategory: doc['subcategory'] ?? '',
        subSubCategories: doc['sub_subcategories'] ?? '',
        language: doc['language'] ?? '',
        courseType: doc['coureType'] ?? '',
        // category: doc.data().toString().contains('category') ? doc['category'] : null,
      );
    } catch (e) {
      // In case videos subcollection doesn't exist or has an error
      return Course(
        id: doc.id,
        name: doc['name'] ?? '',
        price: (doc['price'] != null) ? doc['price'].toString() : '',
        thumbnail: doc['thumbnailUrl'] ?? '',
        description: doc['description'] ?? '',
        category: doc['category'] ?? '',
        subCategory: doc['subcategory'] ?? '',
        subSubCategories: doc['sub_subcategories'] ?? '',
        language: doc['language'] ?? '',
        courseType: doc['coureType'] ?? '',
        videos: [],
        // category: doc.data().toString().contains('category') ? doc['category'] : null,
      );
    }
  }
}
