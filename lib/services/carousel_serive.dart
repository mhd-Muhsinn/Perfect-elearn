import 'package:cloud_firestore/cloud_firestore.dart';

class CarouselService {
  final _firestore = FirebaseFirestore.instance;



  Stream<List<String>> streamCarouselImages() {
  return _firestore.collection('carousel_images').snapshots().map(
    (snapshot) => snapshot.docs
        .map((doc) => doc['image_url'] as String)
        .toList(),
  );
}

}
