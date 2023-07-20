import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';
import 'package:sigalogin/pantallas/DashboardScreen.dart';
import 'package:sigalogin/pantallas/login/registrarUsuario.dart';
import 'package:sigalogin/servicios/authServices.dart';

import '../../clases/global.dart';
import '../../provider/login_from_prodivder.dart';
import '../../servicios/notifications_service.dart';
import '../../ui/InputDecorations.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/card_container.dart';

class LoginScreen extends StatefulWidget {
  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<LoginScreen> {
  bool isChecked = false;
  bool isLoading = false;
  bool permiso = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String? selectedValue;

  final _formlogin = GlobalKey<FormState>();
  final loginForm = Provider.of<LoginFormProvider>;
  late Box box1;
  @override
  void initState() {
    super.initState();

    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() {
    if (box1.get('email') != null) {
      email.text = box1.get('email');
      isChecked = true;
      permiso = true;
      setState(() {});
    }
    if (box1.get('pass') != null) {
      password.text = box1.get('pass');
      isChecked = true;
      permiso = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(children: [
        SizedBox(height: 250),
        CardContainer(
            child: Column(
          children: [
            SizedBox(height: 10),
            Image.network(
              //       // <-- SEE HERE
              'https://firebasestorage.googleapis.com/v0/b/sigaapp-127c4.appspot.com/o/Siga%20inicio-removebg-preview.jpg?alt=media&token=2fc2f502-65a2-446f-955c-b4695a9da100',
            ),
            SizedBox(height: 15),
            Text('Sistema de Pedidos',
                style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 10),
            Text('Login', style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 30),
            Container(
              child: Form(
                  key: _formlogin,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        onChanged: (value) {
                          limpiarcache();
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecorations.authInputDecoration(
                            hinText: '******@siga.local',
                            labelText: 'Nombre de usuario',
                            prefixIcon: Icons.alternate_email_sharp),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: password,
                        autocorrect: false,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecorations.authInputDecoration(
                            hinText: '********',
                            labelText: 'Contraseña',
                            prefixIcon: Icons.lock_outline),
                        validator: (value) {
                          return (value != null && value.length >= 6)
                              ? null
                              : 'La contraseña debe de ser de 6 caracteres';
                        },
                      ),
                      DropdownButtonFormField(
                        hint: Text('Compañia'),

                        elevation: 4,
                        isDense: true,
                        isExpanded: true,
                        iconSize: 60.0,
                        // onChanged: selectedValue,
                        value: selectedValue,

                        items: <String>['Siga SRl', 'New']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              child: Text(value), value: value);
                        }).toList(),

                        onChanged: (String? value) {
                          selectedValue = value;
                          if (value == 'New') {
                            compagnia = 1;
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Recuerdame',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              })
                        ],
                      ),
                      const SizedBox(height: 30),
                      const SizedBox(height: 50),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey,
                          elevation: 0,
                          color: Colors.deepPurple,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            child: const Text('Ingresar',
                                style: TextStyle(color: Colors.white)),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (permiso == true) {
                              var correo =
                                  email.text.replaceAll('@gmail.com', '');
                              correo = email.text.replaceAll('@siga.local', '');

                              usuario = correo;
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen()));
                            } else {
                              final authServices = Provider.of<AuthServices>(
                                  context,
                                  listen: false);
                              if (_formlogin.currentState!.validate()) {
                                final String? errorMessage = await authServices
                                    .login(email.text, password.text);
                                if (errorMessage == null) {
                                  isLoading = true;
                                  login(isChecked, isLoading);
                                  Navigator.of(context)
                                      .pushReplacementNamed('home');
                                } else {
                                  NotificationsService.showSnackbar(
                                      errorMessage);
                                }
                              }
                            }
                          }),
                    ],
                  )),
            )
          ],
        )),
        SizedBox(height: 50),
        SizedBox(height: 50),
      ]),
    )));
  }

  void login(bool isChecked, bool isLoading) {
    if (isChecked == true && isLoading == true) {
      box1.put('email', email.text);
      box1.put('pass', password.text);
    }
  }

  void limpiarcache() {
    box1.clear();
    setState(() {
      isChecked = false;
    });
  }
}


 

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: AuthBackground(
//             child: SingleChildScrollView(
//       child: Column(children: [
//         SizedBox(height: 250),
//         CardContainer(
//             child: Column(
//           children: [
//             SizedBox(height: 10),
//             Image.network(
//               //       // <-- SEE HERE
//               'https://firebasestorage.googleapis.com/v0/b/sigaapp-127c4.appspot.com/o/Siga%20inicio-removebg-preview.jpg?alt=media&token=2fc2f502-65a2-446f-955c-b4695a9da100',
//             ),
//             SizedBox(height: 15),
//             Text('Sistema de Pedidos',
//                 style: Theme.of(context).textTheme.headline4),
//             SizedBox(height: 10),
//             Text('Login', style: Theme.of(context).textTheme.headline4),
//             SizedBox(height: 30),
//             // ChangeNotifierProvider(
//             //   create: (_) => LoginFormProvider(),
//             //   child: _LoginForm(),
//             // )
//           ],
//         )),
//         SizedBox(height: 50),
//         SizedBox(height: 50),
//       ]),
//     )));
//   }
// }

// class _LoginForm extends StatelessWidget {
//   late Box box1;

//   @override
//   bool isChecked = false;
//   void createBox() async {
//     box1 = await Hive.openBox('logindata');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginForm = Provider.of<LoginFormProvider>(context);

//     return Container(
//       child: Form(
//           key: loginForm.formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             children: [
//               TextFormField(
//                 autocorrect: false,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecorations.authInputDecoration(
//                     hinText: '******@siga.local',
//                     labelText: 'Nombre de usuario',
//                     prefixIcon: Icons.alternate_email_sharp),
//                 onChanged: (value) => loginForm.email = value,
//               ),
//               SizedBox(height: 30),
//               TextFormField(
//                 autocorrect: false,
//                 obscureText: true,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecorations.authInputDecoration(
//                     hinText: '********',
//                     labelText: 'Contraseña',
//                     prefixIcon: Icons.lock_outline),
//                 onChanged: (value) => loginForm.password = value,
//                 validator: (value) {
//                   return (value != null && value.length >= 6)
//                       ? null
//                       : 'La contraseña debe de ser de 6 caracteres';
//                 },
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Recuerdame',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   Checkbox(
//                       value: isChecked,
//                       onChanged: (value) {
//                         isChecked = !isChecked;
//                       })
//                 ],
//               ),
//               const SizedBox(height: 30),
//               const SizedBox(height: 50),
//               MaterialButton(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   disabledColor: Colors.grey,
//                   elevation: 0,
//                   color: Colors.deepPurple,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 80, vertical: 15),
//                     child: const Text('Ingresar',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   onPressed: () async {
//                     FocusScope.of(context).unfocus();
//                     final authServices =
//                         Provider.of<AuthServices>(context, listen: false);
//                     if (!loginForm.isValidForm()) return;
//                     loginForm.isLoading = true;
//                     final String? errorMessage = await authServices.login(
//                         loginForm.email, loginForm.password);
//                     usuario = loginForm.email.replaceAll('@gmail.com', '');

//                     if (errorMessage == null) {
//                       loginForm.isLoading = true;
//                       Navigator.pushReplacementNamed(context, 'home');
//                     } else {
//                       NotificationsService.showSnackbar(errorMessage);
//                       loginForm.isLoading = false;
//                     }
//                   }),
//             ],
//           )),
//     );
//   }
// }
