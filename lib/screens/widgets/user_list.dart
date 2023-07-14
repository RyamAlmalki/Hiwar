import 'package:flutter/material.dart';

import '../../const.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Morning!', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
              CircleAvatar(
                radius: 10,
                backgroundColor: primaryColor, 
                child:  const Padding(
                  padding:  EdgeInsets.all(1.0),
                  child:  Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ), 
        tileColor: background,
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ryam malki', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
            Text('Tue', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
          ],
        ),
        onTap: (){
          Navigator.of(context).pushReplacementNamed('messageScreen');
        },
      ),
    );
  }
}