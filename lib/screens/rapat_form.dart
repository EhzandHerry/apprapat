import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apprapat/controllers/rapat_controller.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:intl/intl.dart'; // Tambahkan package ini untuk format tanggal

class RapatFormScreen extends StatelessWidget {
  final Rapat? rapat;

  RapatFormScreen({this.rapat});

  final TextEditingController agendaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController hasilController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (rapat != null) {
      agendaController.text = rapat!.agenda;
      tanggalController.text = rapat!.tanggal;
      jamController.text = rapat!.jam;
      lokasiController.text = rapat!.lokasi;
      hasilController.text = rapat!.hasil ?? '';
      kategoriController.text = rapat!.kategori;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(rapat == null ? 'Tambah Rapat' : 'Edit Rapat'),
        backgroundColor: Colors.blueAccent,
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rapat == null ? 'Tambah Rapat' : 'Edit Rapat',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildTextFormField(agendaController, 'Agenda', Icons.event_note),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextFormField(
                                tanggalController,
                                'Tanggal',
                                Icons.date_range,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildTextFormField(jamController, 'Jam', Icons.access_time, keyboardType: TextInputType.datetime),
                        SizedBox(height: 16),
                        _buildTextFormField(lokasiController, 'Lokasi', Icons.location_on),
                        SizedBox(height: 16),
                        _buildTextFormField(hasilController, 'Hasil', Icons.notes),
                        SizedBox(height: 16),
                        _buildTextFormField(kategoriController, 'Kategori', Icons.category),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final rapatData = Rapat(
                                id: rapat?.id ?? 0,
                                agenda: agendaController.text,
                                tanggal: tanggalController.text,
                                jam: jamController.text,
                                lokasi: lokasiController.text,
                                hasil: hasilController.text,
                                kategori: kategoriController.text,
                              );

                              if (rapat == null) {
                                await Provider.of<RapatController>(context, listen: false)
                                    .createRapat(context, rapatData);
                              } else {
                                await Provider.of<RapatController>(context, listen: false)
                                    .updateRapat(context, rapat!.id, rapatData);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(rapat == null ? 'Tambah' : 'Update'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (selected != null) {
      tanggalController.text = DateFormat('yyyy-MM-dd').format(selected);
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText, IconData icon, {TextInputType keyboardType = TextInputType.text, bool obscureText = false, bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
