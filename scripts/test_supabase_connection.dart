import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Verificando conexión y datos de Supabase...');

  // Leer variables de entorno del archivo .env
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ Error: Archivo .env no encontrado');
    exit(1);
  }

  final envContent = await envFile.readAsString();
  final envLines = envContent.split('\n');

  String? supabaseUrl;
  String? supabaseKey;

  for (final line in envLines) {
    if (line.startsWith('SUPABASE_URL=')) {
      supabaseUrl = line.substring('SUPABASE_URL='.length).trim();
    } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
      supabaseKey = line.substring('SUPABASE_ANON_KEY='.length).trim();
    }
  }

  if (supabaseUrl == null || supabaseKey == null) {
    print(
      '❌ Error: Variables de entorno SUPABASE_URL o SUPABASE_ANON_KEY no encontradas en .env',
    );
    exit(1);
  }

  print('📍 URL: $supabaseUrl');
  print('🔑 Key: ${supabaseKey.substring(0, 20)}...');

  // Verificar las tablas principales
  final tables = [
    'brands',
    'categories',
    'subcategories',
    'suppliers',
    'products',
  ];

  final client = http.Client();

  try {
    for (final table in tables) {
      print('\n📋 Verificando tabla: $table');
      print('=' * 40);

      try {
        final url = Uri.parse('$supabaseUrl/rest/v1/$table?limit=5');
        final response = await client.get(
          url,
          headers: {
            'apikey': supabaseKey,
            'Authorization': 'Bearer $supabaseKey',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List;
          print('✅ Tabla $table accesible');
          print('📊 Registros encontrados: ${data.length}');

          if (data.isNotEmpty) {
            print('📝 Ejemplo de registro:');
            print(json.encode(data[0]));
          } else {
            print('⚠️  La tabla $table está vacía');
          }
        } else {
          print('❌ Error al acceder a la tabla $table: ${response.statusCode}');
          print('Respuesta: ${response.body}');
        }
      } catch (e) {
        print('❌ Error al acceder a la tabla $table: $e');
      }
    }

    // Verificar tabla de price_lists
    try {
      print('\n💰 Verificando tabla: price_lists');
      print('=' * 40);

      final url = Uri.parse('$supabaseUrl/rest/v1/price_lists?limit=5');
      final response = await client.get(
        url,
        headers: {
          'apikey': supabaseKey,
          'Authorization': 'Bearer $supabaseKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        print('✅ Tabla price_lists accesible');
        print('📊 Listas de precios encontradas: ${data.length}');

        if (data.isNotEmpty) {
          print('📝 Ejemplo de lista de precios:');
          print(json.encode(data[0]));
        } else {
          print('⚠️  La tabla price_lists está vacía');
        }
      } else {
        print(
          '❌ Error al acceder a la tabla price_lists: ${response.statusCode}',
        );
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('❌ Error al acceder a la tabla price_lists: $e');
    }

    // Verificar tabla de price_list_items
    try {
      print('\n💵 Verificando tabla: price_list_items');
      print('=' * 40);

      final url = Uri.parse('$supabaseUrl/rest/v1/price_list_items?limit=5');
      final response = await client.get(
        url,
        headers: {
          'apikey': supabaseKey,
          'Authorization': 'Bearer $supabaseKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        print('✅ Tabla price_list_items accesible');
        print('📊 Items de precios encontrados: ${data.length}');

        if (data.isNotEmpty) {
          print('📝 Ejemplo de item de precio:');
          print(json.encode(data[0]));
        } else {
          print('⚠️  La tabla price_list_items está vacía');
        }
      } else {
        print(
          '❌ Error al acceder a la tabla price_list_items: ${response.statusCode}',
        );
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('❌ Error al acceder a la tabla price_list_items: $e');
    }

    print('\n🎉 Verificación completada');
  } finally {
    client.close();
  }
}
