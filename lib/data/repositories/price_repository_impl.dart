import '../../domain/entities/price_list.dart';
import '../../domain/repositories/price_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/remote/remote_datasource.dart';
import '../datasources/local/local_datasource.dart';

class PriceRepositoryImpl implements PriceRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;
  
  PriceRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
  );

  @override
  Future<List<PriceList>> getPriceLists() async {
    return await _localDatasource.getPriceLists();
  }

  @override
  Future<PriceList?> getDefaultPriceList() async {
    return await _localDatasource.getDefaultPriceList();
  }

  @override
  Future<double?> getProductPrice(String priceListId, String productId) async {
    return await _localDatasource.getProductPrice(priceListId, productId);
  }

  @override
  Future<void> syncPrices() async {
    if (!ConnectivityService.isOnline) return;
    
    try {
      final remotePriceItems = await _remoteDatasource.getPriceListItems();
      await _localDatasource.savePriceListItems(remotePriceItems);
    } catch (e) {
      throw Exception('Failed to sync prices: $e');
    }
  }
}