#!/bin/bash

# Script para configurar variables de entorno
# Uso: ./scripts/setup_env.sh

echo "🚀 Configurando variables de entorno para Precios Catálogo..."
echo ""

# Verificar si .env ya existe
if [ -f ".env" ]; then
    echo "⚠️  El archivo .env ya existe."
    read -p "¿Quieres sobrescribirlo? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Configuración cancelada."
        exit 1
    fi
fi

# Copiar archivo de ejemplo
if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "✅ Archivo .env creado desde .env.example"
else
    echo "❌ Error: No se encontró .env.example"
    exit 1
fi

echo ""
echo "📝 Ahora necesitas editar el archivo .env con tus credenciales reales:"
echo ""
echo "1. Abre el archivo .env en tu editor favorito:"
echo "   nano .env"
echo "   # o"
echo "   code .env"
echo ""
echo "2. Reemplaza los valores de ejemplo con tus credenciales de Supabase:"
echo "   - SUPABASE_URL: Tu URL de proyecto Supabase"
echo "   - SUPABASE_ANON_KEY: Tu clave anónima de Supabase"
echo ""
echo "3. Guarda el archivo y ejecuta:"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "📚 Para más información, consulta ENV_SETUP.md"
