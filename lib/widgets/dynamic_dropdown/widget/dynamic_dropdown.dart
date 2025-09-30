import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/widgets/dynamic_dropdown/cubit/drop_down_cubit.dart';

class DynamicDropdown extends StatelessWidget {
  final String title;
  final String firestoreField;
  final String? nestedKey; // for nested maps
  final dynamic currentValue;
  final Function(dynamic) onChanged;

  const DynamicDropdown({
    super.key,
    required this.title,
    required this.firestoreField,
    this.nestedKey,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DynamicDropdownCubit(firestoreField, nestedKey: nestedKey),
      child: BlocBuilder<DynamicDropdownCubit, List<String>>(
        builder: (context, items) {
          return DropdownButtonFormField(
            dropdownColor: PColors.backgrndPrimary,
            decoration: InputDecoration(labelText: title,fillColor: PColors.primaryVariant,border: OutlineInputBorder()),
            value: items.contains(currentValue) ? currentValue : null,
            items: [
              ...items.map((e) => DropdownMenuItem(child: Text(e), value: e)),
           
            ],
            onChanged: (val) async {
    
                onChanged(val);
         
            },
          );
        },
      ),
    );
  }
}


