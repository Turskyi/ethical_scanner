abstract class LocalDataSource {
  const LocalDataSource();
  String getCountryFromBarcode(String barcode);
  bool isEnglishBook(String barcode);
}