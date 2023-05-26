// import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
// import 'package:flutter/material.dart';
// import 'package:one_minute_recording/main.dart';
// import 'package:one_minute_recording/record.dart';
// import 'const/constants.dart';
//
// class CategoryPage extends StatelessWidget {
//   const CategoryPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
//             child: SizedBox(
//                 height: 400,
//                 width: double.infinity,
//                 child: DynamicHeightGridView(
//                   crossAxisCount: 3,
//                   shrinkWrap: true,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   itemCount: group.toList().length,
//                   builder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         int i =0;
//                         for ( i ; i < group.length ; i++) {
//                           print('Group: ${group.toList()[i]}');
//                           for (Map<String, dynamic> question in questionList) {
//                             if (question.containsValue('${group.toList()[i]}') && '${group.toList()[i]}' == group.elementAt(i))
//                             {
//                               newList['${group.toList()[i]}'] = [];
//                               newList["${group.toList()[i]}"]!.add(question['question']);
//
//                               print(newList["${group.toList()[i]}"]);
//                             }
//                           }
//                           print('---');
//                         }
//                         print('grid no ${group.toList()[index]} tapped');
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AudioPage(newList: newList.values)),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.teal,
//                         ),
//                         padding: EdgeInsets.all(15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Text(
//                               group.toList()[index],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
