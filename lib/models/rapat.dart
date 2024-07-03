class Rapat {
  final int id;
  final String agenda;
  final String tanggal;
  final String jam;
  final String lokasi;
  final String? hasil;
  final String kategori;

  Rapat({
    required this.id,
    required this.agenda,
    required this.tanggal,
    required this.jam,
    required this.lokasi,
    this.hasil,
    required this.kategori,
  });

  factory Rapat.fromJson(Map<String, dynamic> json) {
    return Rapat(
      id: json['id'],
      agenda: json['agenda'],
      tanggal: json['tanggal'],
      jam: json['jam'],
      lokasi: json['lokasi'],
      hasil: json['hasil'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agenda': agenda,
      'tanggal': tanggal,
      'jam': jam,
      'lokasi': lokasi,
      'hasil': hasil,
      'kategori': kategori,
    };
  }
}
