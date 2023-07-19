import 'package:flutter/material.dart';

import '../../../const.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width ,
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Search',
            labelStyle: TextStyle(color: textColor),
            prefixIcon: Icon(Icons.search, color: textColor,),
            filled: true,
            fillColor: accentColor,
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 0, color: background), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
              
            ),
            
          ),
          onChanged: (value) {
            
          },
        ),
      ),
    );
  }
}