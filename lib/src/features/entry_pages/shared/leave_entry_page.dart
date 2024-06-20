// import 'package:flutter/material.dart';

// class WillPopHandler extends StatelessWidget {
//   final Widget child;
//   final String message;
//   final String title;
//   final String cancelText;
//   final String confirmText;

//   const WillPopHandler({
//     super.key,
//     required this.child,
//     this.message = ' will discard all changes.',
//     this.title = 'Are you sure?',
//     this.cancelText = 'Cancel',
//     this.confirmText = 'Leave', required Future<bool> Function() onWillPop,
//   });

//   Future<bool> _onWillPop(BuildContext context) async {
//     return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message,
//             style:const TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               )),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(cancelText),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text(confirmText),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: deprecated_member_use
//     return WillPopScope(
//       onWillPop: () => _onWillPop(context),
//       child: child,
//     );
//   }
// }
