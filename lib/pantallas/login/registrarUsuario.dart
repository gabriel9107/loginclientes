import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../clases/themes.dart';
import '../../provider/login_from_prodivder.dart';
import '../../servicios/authServices.dart';
import '../../servicios/notifications_service.dart';
import '../../ui/InputDecorations.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/card_container.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(children: [
        AppBar(
          backgroundColor: Color.fromARGB(255, 61, 64, 238),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        SizedBox(height: 350),
        CardContainer(
            child: Column(
          children: [
            SizedBox(height: 10),
            Image.network(
              //       // <-- SEE HERE
              'https://firebasestorage.googleapis.com/v0/b/sigaapp-127c4.appspot.com/o/Siga%20inicio.PNG?alt=media&token=b23f275a-b8f1-4656-9f1d-7127ace42ca4',
            ),
            SizedBox(height: 15),
            Text('Sistema de Pedidos',
                style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 10),

            SizedBox(height: 30),
            ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: _LoginForm(),
            )
            // _LoginForm()
          ],
        )),
        SizedBox(height: 50),
        // Text('Tienes una cuenta ?', style: TextStyle(fontSize: 18)),
        SizedBox(height: 50),
      ]),
    )

            // Container(
            //   width: double.infinity,
            //   height: 300,
            //   color: Colors.red,
            // ),
            ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hinText: '40221025725',
                    labelText: 'Nombre de usuario',
                    prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) => loginForm.email = value,
              ),
              SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hinText: '********',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe de ser de 6 caracteres';
                },
              ),
              SizedBox(height: 50),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child:
                        Text('Ingresar', style: TextStyle(color: Colors.white)),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    final authservices =
                        Provider.of<AuthServices>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    final String? errorMessage = await authservices.createUser(
                        loginForm.email, loginForm.password);

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed((context), 'home');
                    }

                    print(errorMessage);
                    NotificationsService.showSnackbar(errorMessage.toString());

                    loginForm.isLoading = false;
                  }),
            ],
          )),
    );
  }
}
