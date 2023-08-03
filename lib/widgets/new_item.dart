import 'dart:convert';

import 'package:book_library_app_ui/data/categories.dart';
import 'package:book_library_app_ui/models/category.dart';
import 'package:book_library_app_ui/models/grocery_items.dart';
// import 'package:book_library_app_ui/models/grocery_items.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      // try {
      final url = Uri.https(
        'flutter-rep-42cb7-default-rtdb.firebaseio.com',
        '/shopping-list.json',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': enteredQuantity,
            'category': _selectedCategory.title,
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: enteredQuantity,
          category: _selectedCategory));

      // if (response.statusCode == 200) {
      //   print('Item saved successfully');
      // } else {
      //   print('Failed to save item : ${response.statusCode}');
      // }
      // } catch (e) {
      //   print('EXception occurred during save :$e');
      // }

      // Navigator.of(context).pop();

      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: enteredQuantity,
      //     category: _selectedCategory,
      //   ),
      // );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add a new item',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 Charact...';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valud positive number...';
                        }
                        return null;
                      },
                      onSaved: (newValue) {},
                      keyboardType: TextInputType.number,
                      initialValue: enteredQuantity.toString(),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories
                            .entries) //we can use enteries into iterable.
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  category.value.title,
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    // using map insetead of for in
// DropdownButtonFormField<Category>(
//                       value: null, // You can set a default value here if needed
//                       onChanged: (value) {},
//                       items: categories.entries
//                           .map((category) => DropdownMenuItem(
//                                 value: category.value,
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 16,
//                                       height: 16,
//                                       color: category.value.color,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       category.value.title,
//                                     ),
//                                   ],
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                   ),
//                 ],
//               ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Rest'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Add Item',
                            style: TextStyle(),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
