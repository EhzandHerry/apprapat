import 'package:apprapat/widgets/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apprapat/controllers/rapat_controller.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:intl/intl.dart';

class RapatFormScreen extends StatefulWidget {
  final Rapat? rapat;

  RapatFormScreen({this.rapat});

  @override
  _RapatFormScreenState createState() => _RapatFormScreenState();
}

class _RapatFormScreenState extends State<RapatFormScreen> {
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController hasilController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  String? _lokasi;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.rapat != null) {
      agendaController.text = widget.rapat!.agenda;
      tanggalController.text = widget.rapat!.tanggal;
      jamController.text = widget.rapat!.jam;
      lokasiController.text = widget.rapat!.lokasi;
      _lokasi = widget.rapat!.lokasi;
      hasilController.text = widget.rapat!.hasil ?? '';
      kategoriController.text = widget.rapat!.kategori;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rapat == null ? 'Tambah Rapat' : 'Edit Rapat'),
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
                          widget.rapat == null ? 'Tambah Rapat' : 'Edit Rapat',
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
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextFormField(
                                jamController,
                                'Jam',
                                Icons.access_time,
                                readOnly: true,
                                onTap: () => _selectTime(context),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () => _selectTime(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildLokasiField(context),
                        SizedBox(height: 16),
                        _buildTextFormField(hasilController, 'Hasil', Icons.notes),
                        SizedBox(height: 16),
                        _buildTextFormField(kategoriController, 'Kategori', Icons.category),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final rapatData = Rapat(
                                id: widget.rapat?.id ?? 0,
                                agenda: agendaController.text,
                                tanggal: tanggalController.text,
                                jam: jamController.text,
                                lokasi: lokasiController.text.isNotEmpty ? lokasiController.text : _lokasi ?? '',
                                hasil: hasilController.text,
                                kategori: kategoriController.text,
                              );

                              if (widget.rapat == null) {
                                await Provider.of<RapatController>(context, listen: false)
                                    .createRapat(context, rapatData);
                              } else {
                                await Provider.of<RapatController>(context, listen: false)
                                    .updateRapat(context, widget.rapat!.id, rapatData);
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
                          child: Text(widget.rapat == null ? 'Tambah' : 'Update'),
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

  Widget _buildLokasiField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi', style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(lokasiController, 'Lokasi', Icons.location_on),
            ),
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                        onLocationSelected: (selectedAddress) {
                      setState(() {
                        _lokasi = selectedAddress;
                        lokasiController.text = selectedAddress;
                      });
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ],
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

  void _selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(now.year, now.month, now.day, selected.hour, selected.minute);
      jamController.text = DateFormat('HH:mm:ss').format(selectedDateTime);
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
