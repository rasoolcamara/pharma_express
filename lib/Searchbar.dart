import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _medicines = [    'Aspirin',    'Paracetamol',    'Ibuprofen',    'Acetaminophen',    'Naproxen',    'Ciprofloxacin',    'Metronidazole',    'Azithromycin',    'Ceftriaxone',    'Doxycycline',  ];
  List<String> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    _filteredMedicines.addAll(_medicines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Recherche',
          ),
          onChanged: (value) {
            setState(() {
              _filteredMedicines = _medicines
                  .where((medicine) =>
                  medicine.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredMedicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredMedicines[index]),
          );
        },
      ),
    );
  }
}
//Cela permettra de créer une barre de recherche qui filtre la liste des médicaments en fonction de la valeur de la recherche.






