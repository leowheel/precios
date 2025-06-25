#!/bin/bash

# Script para verificar la estructura de tablas en Supabase
# Uso: ./scripts/check_supabase_tables.sh

SUPABASE_URL="${1:-YOUR_SUPABASE_URL}"
SUPABASE_ANON_KEY="${2:-YOUR_SUPABASE_ANON_KEY}"

if [[ "$SUPABASE_URL" == "YOUR_SUPABASE_URL" ]] || [[ "$SUPABASE_ANON_KEY" == "YOUR_SUPABASE_ANON_KEY" ]]; then
    echo "❌ Por favor proporciona las credenciales de Supabase:"
    echo "Uso: $0 <SUPABASE_URL> <SUPABASE_ANON_KEY>"
    echo ""
    echo "Ejemplo:"
    echo "$0 https://xxx.supabase.co your-anon-key"
    exit 1
fi

echo "🔍 Verificando conexión a Supabase..."
echo "URL: $SUPABASE_URL"
echo ""

# Array de tablas a verificar
tables=("brands" "categories" "suppliers" "products")

for table in "${tables[@]}"; do
    echo "📋 Verificando tabla: $table"
    echo "================================"
    
    # Hacer request para obtener un registro de muestra
    response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        "$SUPABASE_URL/rest/v1/$table?limit=1")
    
    # Extraer el código de estado HTTP
    http_status=$(echo "$response" | grep "HTTP_STATUS:" | cut -d: -f2)
    body=$(echo "$response" | sed '/HTTP_STATUS:/d')
    
    if [[ "$http_status" == "200" ]]; then
        echo "✅ Tabla accesible"
        echo "Datos de muestra:"
        echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    else
        echo "❌ Error al acceder a la tabla (HTTP $http_status)"
        echo "Respuesta: $body"
    fi
    
    echo ""
done

echo "🔍 Verificando estructura de la base de datos..."

# Intentar obtener información del esquema
schema_response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
    "$SUPABASE_URL/rest/v1/?select=*" 2>/dev/null)

echo "Análisis completado."