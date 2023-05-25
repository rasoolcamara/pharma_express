import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'PharmaExpress'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late String valueChoose = "Les Pharmacies qui sont accessibles autour de moi";
  List<String> listItem = [
    "Les Pharmacies qui sont accessibles autour de moi",
    "Numéros utiles",
    "A propos"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton(
                hint: Text("Select Items: "),
                dropdownColor: Colors.green,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(color: Colors.black, fontSize: 22),
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue.toString();
                  });
                },
                items: listItem.map((valuepharmacie) {
                  return DropdownMenuItem(
                    value: valuepharmacie,
                    child: Text(valuepharmacie),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Recherche',
              ),
              onChanged: (value) {
                // Ajoutez votre logique de filtrage ici
                // Par exemple, mettez à jour une liste filtrée en fonction de la valeur de recherche
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
              4, // Remplacez cette valeur par la taille de votre liste filtrée
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Pharmacie $index'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
//Ce code affiche une barre de recherche et une liste filtrée