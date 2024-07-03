import 'package:apprapat/screens/admin_rapat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apprapat/controllers/rapat_controller.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:apprapat/screens/rapat_detail.dart';
import 'package:apprapat/screens/rapat_form.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RapatController()..fetchRapats(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome Admin!'),
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search by Agenda',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
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
                        final filteredRapats = rapatController.rapats
                            .where((rapat) =>
                                rapat.agenda.toLowerCase().contains(searchQuery.toLowerCase()))
                            .toList();
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
                                      builder: (context) => AdminRapatDetailScreen(rapat: rapat),
                                    ),
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RapatFormScreen(rapat: rapat),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () {
                                        rapatController.deleteRapat(rapat.id);
                                      },
                                    ),
                                  ],
                                ),
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
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RapatFormScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Tambahkan Rapat'),
        ),
      ),
    );
  }
}
