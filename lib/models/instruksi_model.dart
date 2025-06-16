class Instruksi {
  final String instruksi;

  Instruksi({required this.instruksi});

  factory Instruksi.fromRTDB(Map<String, dynamic> data) {
    return Instruksi(
      instruksi: data['instruksi']
    );
  }
}
