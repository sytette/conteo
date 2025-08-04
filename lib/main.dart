import 'package:flutter/material.dart';

void main() => runApp(ConteoApp());

class ConteoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conteo de Computadoras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Pantalla1(),
    );
  }
}

class Pantalla1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Iniciar Conteo"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: TextStyle(fontSize: 24),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pantalla2()),
          ),
        ),
      ),
    );
  }
}

class Pantalla2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Opciones")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Valores predeterminados"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pantalla3()),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Conteo"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pantalla4()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Global storage
Map<String, int> valoresPredeterminados = {};
Map<String, int> conteoReal = {};

class Pantalla3 extends StatefulWidget {
  @override
  _Pantalla3State createState() => _Pantalla3State();
}

class _Pantalla3State extends State<Pantalla3> {
  final cursos = [
    '1A', '1B', '2A', '2B', '3A', '3B', '4A', '4B', '5A', '5B', '6A', '6B'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Valores Predeterminados")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          buildSection("Primaria"),
          SizedBox(height: 20),
          buildSection("Secundaria"),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Volver"),
            onPressed: () => Navigator.pop(context),
          )
        ]),
      ),
    );
  }

  Widget buildSection(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        DataTable(
          columns: [
            DataColumn(label: Text("Curso")),
            DataColumn(label: Text("Cantidad")),
          ],
          rows: cursos.map((curso) {
            String key = "$titulo-$curso";
            return DataRow(cells: [
              DataCell(Text(curso)),
              DataCell(
                TextFormField(
                  initialValue: valoresPredeterminados[key]?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      valoresPredeterminados[key] = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ]);
          }).toList(),
        )
      ],
    );
  }
}

class Pantalla4 extends StatefulWidget {
  @override
  _Pantalla4State createState() => _Pantalla4State();
}

class _Pantalla4State extends State<Pantalla4> {
  final cursos = [
    '1A', '1B', '2A', '2B', '3A', '3B', '4A', '4B', '5A', '5B', '6A', '6B'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conteo Real")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          buildSection("Primaria"),
          SizedBox(height: 20),
          buildSection("Secundaria"),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Finalizar"),
            onPressed: () {
              String resumen = '';
              valoresPredeterminados.forEach((key, valorPred) {
                final valorReal = conteoReal[key] ?? 0;
                if (valorPred != valorReal) {
                  resumen += '$key: Esperado $valorPred, Real $valorReal\n';
                }
              });

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Comparación"),
                  content: Text(resumen.isEmpty
                      ? "Todo coincide correctamente."
                      : resumen),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
            },
          )
        ]),
      ),
    );
  }

  Widget buildSection(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        DataTable(
          columns: [
            DataColumn(label: Text("Curso")),
            DataColumn(label: Text("Cantidad Pred.")),
            DataColumn(label: Text("Conteo")),
          ],
          rows: cursos.map((curso) {
            String key = "$titulo-$curso";
            return DataRow(cells: [
              DataCell(Text(curso)),
              DataCell(Text(valoresPredeterminados[key]?.toString() ?? '0')),
              DataCell(
                TextFormField(
                  initialValue: conteoReal[key]?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      conteoReal[key] = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ]);
          }).toList(),
        )
      ],
    );
  }
}
