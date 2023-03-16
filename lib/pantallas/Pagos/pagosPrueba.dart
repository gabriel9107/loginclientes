// import 'package:flutter/material.dart';

// class MyCustomForm extends StatefulWidget {
//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }

// // Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// // el formulario.
// class MyCustomFormState extends State<MyCustomForm> {
//   // Crea una clave global que identificará de manera única el widget Form
//   // y nos permita validar el formulario
//   //
//   // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     // Crea un widget Form usando el _formKey que creamos anteriormente
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextFormField(
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some text';
//               }
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: RaisedButton(
//               onPressed: () {
//                 // devolverá true si el formulario es válido, o falso si
//                 // el formulario no es válido.
//                 if (_formKey.currentState.validate()) {
//                   // Si el formulario es válido, queremos mostrar un Snackbar
//                   Scaffold.of(context)
//                       .showSnackBar(SnackBar(content: Text('Processing Data')));
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
