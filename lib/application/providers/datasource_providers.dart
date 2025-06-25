import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../core/services/database_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final remoteDatasourceProvider = Provider<RemoteDatasource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return RemoteDatasource(supabaseClient);
});

final localDatasourceProvider = Provider<LocalDatasource>((ref) {
  return DatabaseService.localDatasource;
});