import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sigalogin/pantallas/login/registrarUsuario.dart';
import 'package:sigalogin/servicios/authServices.dart';

import '../../clases/global.dart';
import '../../provider/login_from_prodivder.dart';
import '../../servicios/notifications_service.dart';
import '../../ui/InputDecorations.dart';
import '../../widgets/auth_background.dart';
import '../../widgets/card_container.dart';

class LoginScreen extends StatelessWidget {
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
              'https://firebasestorage.googleapis.com/v0/b/sigaapp-127c4.appspot.com/o/Siga%20inicio.PNG?alt=media&token=b23f275a-b8f1-4656-9f1d-7127ace42ca4',
            ),
            SizedBox(height: 15),
            Text('Sistema de Pedidos',
                style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 10),
            Text('Login', style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 30),
            ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: _LoginForm(),
            )
            // _LoginForm()
          ],
        )),
        SizedBox(height: 50),
        TextButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                ),
            // Navigator.pushReplacementNamed(context, 'register'),

            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            child: Text(
              'Crear cuenta',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            )),
        SizedBox(height: 50),
      ]),
    )));
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
                    final authServices =
                        Provider.of<AuthServices>(context, listen: false);
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    final String? errorMessage = await authServices.login(
                        loginForm.email, loginForm.password);
                    usuario = loginForm.email.replaceAll('@gmail.com', '');

                    if (errorMessage == null) {
                      loginForm.isLoading = true;
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      NotificationsService.showSnackbar(errorMessage);
                      loginForm.isLoading = false;
                    }
                  }),
            ],
          )),
    );
  }
}
