class Bahan {
  final String bahan;

  Bahan({required this.bahan});

  factory Bahan.fromRTDB(Map<String, dynamic> data) {
    return Bahan(
      bahan: data['bahan'],
    );
  }
}
