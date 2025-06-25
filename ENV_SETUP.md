# Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para proteger información sensible como las credenciales de Supabase.

## Configuración Inicial

1. **Copia el archivo de ejemplo:**

   ```bash
   cp .env.example .env
   ```

2. **Edita el archivo `.env` con tus credenciales reales:**

   ```bash
   nano .env
   ```

3. **Configura las siguientes variables:**

```env
# Configuración de Supabase
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_supabase_anon_key_aqui

# Configuración de la aplicación
APP_NAME=Precios Catálogo
DATABASE_NAME=precios_local.db
DATABASE_VERSION=1
```

## Variables Disponibles

### Supabase

- `SUPABASE_URL`: URL de tu proyecto Supabase
- `SUPABASE_ANON_KEY`: Clave anónima de tu proyecto Supabase

### Aplicación

- `APP_NAME`: Nombre de la aplicación (opcional, valor por defecto: "Precios Catálogo")
- `DATABASE_NAME`: Nombre del archivo de base de datos local (opcional, valor por defecto: "precios_local.db")
- `DATABASE_VERSION`: Versión del esquema de base de datos (opcional, valor por defecto: 1)

## Seguridad

- ✅ El archivo `.env` está incluido en `.gitignore` y no se subirá al repositorio
- ✅ Usa el archivo `.env.example` como plantilla sin credenciales reales
- ✅ Las variables se cargan de forma segura usando `flutter_dotenv`

## Obtener Credenciales de Supabase

1. Ve a [Supabase](https://supabase.com/) y crea una cuenta
2. Crea un nuevo proyecto
3. En el dashboard del proyecto, ve a Settings > API
4. Copia:
   - **URL**: Se encuentra en "Project URL"
   - **Anon Key**: Se encuentra en "Project API keys" como "anon public"

## Solución de Problemas

Si ves errores relacionados con variables de entorno:

1. **Verifica que el archivo `.env` existe:**

   ```bash
   ls -la .env
   ```

2. **Verifica que las variables están configuradas:**

   ```bash
   cat .env
   ```

3. **Asegúrate de que el archivo está incluido en `pubspec.yaml`:**

   ```yaml
   flutter:
     assets:
       - .env
   ```

4. **Si cambias las variables, reinicia la aplicación:**
   ```bash
   flutter run
   ```
