import 'package:flutter/material.dart';

import '../../../shared/const.dart';

class Options extends StatelessWidget {
  const Options({super.key, required this.optionsName, required this.icons, required this.optionsFunctions, required this.title});

  final List<String> optionsName;
  final List<IconData> icons;
  final String title;
  final List<Function> optionsFunctions;
  


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          // Title 
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
              ),
            ],
          ),

          // Top Tile  
          optionsName.length == 1 ? ListTile(
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              )
            ),
            tileColor: accentColor,
            selectedTileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: background,
                child: Icon(icons[0], color: Colors.white,)
              ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(optionsName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            onTap: () {
              optionsFunctions[0]();
            },
          ) : ListTile(
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              )
            ),
            tileColor: accentColor,
            selectedTileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: background,
                child: Icon(icons[0], color: Colors.white,)
              ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(optionsName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            onTap: () {
              optionsFunctions[0]();
            },
          ),

          // Middle Tiles
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: optionsName.length == 1 ?  0 : optionsName.length - 2, 
            itemBuilder: (context, index) { 
            return ListTile(
                tileColor: accentColor,
                selectedTileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundColor: background,
                    child: Icon(icons[index + 1], color: Colors.white,)
                  ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(optionsName[index + 1], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                onTap: () {
                  optionsFunctions[index + 1]();
                },
              );
            },
          ),

          // Bottom Tile 
          optionsName.length > 1 ? ListTile(
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              )
            ),
            tileColor: accentColor,
            selectedTileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: background,
                child: Icon(icons.last, color: Colors.white,)
              ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(optionsName.last, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            onTap: () {
              optionsFunctions[optionsFunctions.length - 1]();
            },
          ): Container()
        ],
      ),
    );
  }
}