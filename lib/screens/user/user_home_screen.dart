import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apprapat/controllers/rapat_controller.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:apprapat/screens/user/rapat_detail.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? selectedCategory;
  final List<String> categories = [
    'All',
    'UMUM',
    'IPTEK',
    'HUMAS',
    'KASTRAD',
    'KWU',
    'KH',
    'SBO',
    'MEDPRO'
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RapatController()..fetchRapats(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Halo, jangan lupa rapat bro!'),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Filter by Kategori',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedCategory,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<RapatController>(
                    builder: (context, rapatController, child) {
                      if (rapatController.rapats.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<Rapat> filteredRapats = selectedCategory == null || selectedCategory == 'All'
                            ? rapatController.rapats
                            : rapatController.rapats.where((rapat) => rapat.kategori == selectedCategory).toList();
                        return ListView.builder(
                          itemCount: filteredRapats.length,
                          itemBuilder: (context, index) {
                            final rapat = filteredRapats[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: ListTile(
                                title: Text(
                                  rapat.agenda,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${rapat.tanggal} - ${rapat.jam}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RapatDetailScreen(rapat: rapat),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
