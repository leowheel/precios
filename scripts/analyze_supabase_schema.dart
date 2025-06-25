import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Script para analizar la estructura de tablas de Supabase
// Uso: dart run scripts/analyze_supabase_schema.dart

const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

Future<void> main() async {
  print('🔍 Analizando estructura de tablas de Supabase...\n');

  // Lista de tablas a analizar
  const tables = ['brands', 'categories', 'suppliers', 'products'];

  for (final table in tables) {
    await analyzeTable(table);
    print('');
  }
}

Future<void> analyzeTable(String tableName) async {
  try {
    print('📋 Analizando tabla: $tableName');
    print('=' * 40);

    // Hacer query básico para obtener estructura
    final url = Uri.parse('$supabaseUrl/rest/v1/$tableName?limit=1');
    final response = await http.get(
      url,
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      if (data.isNotEmpty) {
        final Map<String, dynamic> firstRow = data[0];
        print('Campos encontrados:');
        
        firstRow.forEach((key, value) {
          final type = value.runtimeType.toString();
          final nullableIndicator = value == null ? '(nullable)' : '';
          print('  • $key: $type $nullableIndicator');
        });
        
        print('Total de campos: ${firstRow.keys.length}');
      } else {
        print('Tabla vacía - no se pueden determinar los campos');
      }
      
      // Intentar obtener más información sobre la estructura
      await getTableSchema(tableName);
      
    } else {
      print('Error al acceder a la tabla: ${response.statusCode}');
      print('Respuesta: ${response.body}');
    }
  } catch (e) {
    print('Error analizando tabla $tableName: $e');
  }
}

Future<void> getTableSchema(String tableName) async {
  try {
    // Intentar obtener el esquema usando la API de PostgreSQL
    final url = Uri.parse('$supabaseUrl/rest/v1/rpc/get_table_schema');
    final response = await http.post(
      url,
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'table_name': tableName}),
    );

    if (response.statusCode == 200) {
      final schema = json.decode(response.body);
      print('Esquema detallado disponible: $schema');
    }
  } catch (e) {
    // No es crítico si esto falla
    print('(Esquema detallado no disponible)');
  }
}