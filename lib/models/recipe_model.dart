
class Recipe {
  final String namaMakanan;
  final String deskripsiMasakan;
  final String waktuMasak;
  final String kalori;
  final List<String> bahan; 
  final List<String> instruksi;
  final String urlGambar;


  Recipe({ required this.namaMakanan, required this.deskripsiMasakan, required this.waktuMasak, required this.kalori, required this.bahan, required this.instruksi, required this.urlGambar});

  factory Recipe.fromRTDB(Map<String,dynamic> data) { 
    return Recipe(
    namaMakanan : data['namaMakanan'],
    deskripsiMasakan : data['deskripsiMasakan'], 
    waktuMasak : data['waktuMasak'],
    kalori : data['kalori'],
    bahan : data['bahan'].trim().split(","),
    instruksi : data['instruksi'].trim().split("."),
    urlGambar : data['urlGambarOnline'], 
    );
  }
}
