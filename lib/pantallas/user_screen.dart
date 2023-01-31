import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Gabriel Montero'),
        ),
        body: Image.network(
            'https://www.google.com.do/url?sa=i&url=https%3A%2F%2Fdo.linkedin.com%2Fin%2Fgabriel-montero-terrero-74954a30&psig=AOvVaw1r-xu39f1R2Dpm-bn9-owK&ust=1668020558350000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCJiWpviin_sCFQAAAAAdAAAAABAJ'),
      );
}
