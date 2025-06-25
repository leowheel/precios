import '../entities/price_list.dart';

abstract class PriceRepository {
  Future<List<PriceList>> getPriceLists();
  Future<PriceList?> getDefaultPriceList();
  Future<double?> getProductPrice(String priceListId, String productId);
  Future<void> syncPrices();
}