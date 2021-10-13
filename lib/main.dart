import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyzu_leads/widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Cadastro de Leads Gyzu';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primaryColor: Colors.red),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String telefone = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Form(
          key: formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              buildNome(),
              const SizedBox(height: 16),
              buildEmail(),
              const SizedBox(height: 32),
              buildTelefone(),
              const SizedBox(height: 32),
              buildSubmit(),
            ],
          ),
        ),
      );

  Widget buildNome() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Nome',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value.length < 4) {
            return 'Nome possui menos que 4 caracteres.';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => nome = value),
      );

  Widget buildEmail() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
          final regExp = RegExp(pattern);

          if (value.isEmpty) {
            return 'Digite um email.';
          } else if (!regExp.hasMatch(value)) {
            return 'Digite um email válido.';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => setState(() => email = value),
      );

  Widget buildTelefone() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Telefone',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value.length < 9) {
            return 'Número de caracteres mínimos para telefone é 9.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => telefone = value),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ButtonWidget(
          text: 'Cadastrar',
          onClicked: () {
            final isValid = formKey.currentState.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              formKey.currentState.save();

              final message =
                  'Username: $nome\nPassword: $telefone\nEmail: $email';
              final snackBar = SnackBar(
                content: Text(
                  message,
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      );
}
