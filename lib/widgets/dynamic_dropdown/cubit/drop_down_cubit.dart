import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicDropdownCubit extends Cubit<List<String>> {
  final String firestoreField;
  final String? nestedKey;

  DynamicDropdownCubit(this.firestoreField, {this.nestedKey}) : super([]) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('app-data').doc('main').get();
      dynamic data = doc[firestoreField];
      List<String> values = [];

      if (nestedKey == null) {
        // Direct list from field (e.g., course_categories, languages, course_types)
        if (data is List) {
          values = List<String>.from(data);
        } else {
          values = [];
          print("Firestore field '$firestoreField' is not a List: $data");
        }
      } else {
        // Nested map retrieval (e.g., course_subcategories, course_sub_subcategories)
        if (data is Map && data[nestedKey] is List) {
          values = List<String>.from(data[nestedKey]);
        } else {
          values = [];
          print("Firestore field '$firestoreField' for nestedKey '$nestedKey' is not a List: $data");
        }
      }

      emit(values);
    } catch (e) {
      print('Error fetching items for $firestoreField (nestedKey: $nestedKey): $e');
      emit([]);
    }
  }


}
