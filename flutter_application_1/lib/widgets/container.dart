import 'package:flutter/material.dart';

class  CustomContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 404,
      height: 35,
      decoration: BoxDecoration(
        color: const Color(0xFFFED36A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
        const Text("BUGÜN",style:TextStyle(color:Colors.black,fontSize: 18,fontWeight:FontWeight.bold)),
         IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward)),
      
      ],),
    );
  }
}
