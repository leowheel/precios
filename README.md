# Precios Catálogo

Una aplicación Flutter para gestión de catálogo de productos con sincronización en tiempo real usando Supabase.

## Características

- 📱 **Interfaz intuitiva** con Material Design
- 🔄 **Sincronización offline/online** automática
- 📦 **Gestión de productos** por categorías y marcas
- 💰 **Sistema de precios** con múltiples listas
- 🗃️ **Base de datos local** con Drift/SQLite
- ☁️ **Backend** con Supabase

## Configuración del Proyecto

### 1. Requisitos Previos

- Flutter SDK 3.8.1 o superior
- Dart 3.0 o superior
- Cuenta en [Supabase](https://supabase.com/)

### 2. Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para proteger información sensible:

```bash
# Copia el archivo de ejemplo
cp .env.example .env

# Edita el archivo con tus credenciales
nano .env
```

Configura las siguientes variables en `.env`:

```env
# Configuración de Supabase
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_supabase_anon_key_aqui

# Configuración de la aplicación (opcional)
APP_NAME=Precios Catálogo
DATABASE_NAME=precios_local.db
DATABASE_VERSION=1
```

📋 Ver [ENV_SETUP.md](ENV_SETUP.md) para instrucciones detalladas.

### 3. Instalación

```bash
# Instalar dependencias
flutter pub get

# Generar código (modelos, providers, etc.)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar la aplicación
flutter run
```

## Arquitectura

El proyecto sigue los principios de **Clean Architecture** con:

```
lib/
├── core/              # Configuración base, temas, constantes
├── data/              # Fuentes de datos, modelos, repositorios
├── domain/            # Entidades de negocio, casos de uso
├── application/       # Providers y lógica de estado (Riverpod)
└── presentation/      # UI, páginas y widgets
```

### Tecnologías Utilizadas

- **Estado**: Flutter Riverpod 2.4.9
- **Base de datos local**: Drift 2.14.1
- **Backend**: Supabase Flutter 2.0.0
- **Conectividad**: Connectivity Plus 6.1.4
- **Variables de entorno**: Flutter DotEnv 5.1.0

## Uso

### Sincronización de Datos

1. Abre la aplicación
2. Ve a la página de "Sincronización"
3. Presiona "Sincronizar Ahora"
4. Los datos se descargarán desde Supabase y se guardarán localmente

### Navegación

- **Marcas**: Visualiza y filtra productos por marca
- **Categorías**: Organiza productos por categorías
- **Productos**: Catálogo completo con búsqueda
- **Sincronización**: Gestiona la sincronización de datos

## Desarrollo

### Comandos Útiles

```bash
# Análisis de código
flutter analyze

# Formatear código
dart format .

# Ejecutar tests
flutter test

# Generar código
dart run build_runner build

# Limpiar proyecto
flutter clean && flutter pub get
```

### Solución de Problemas

#### Variables de Entorno

Si ves errores relacionados con Supabase:

1. Verifica que `.env` existe y contiene las variables correctas
2. Revisa los logs de debug para ver qué variables faltan
3. Consulta [ENV_SETUP.md](ENV_SETUP.md) para más ayuda

#### Sincronización

Si la sincronización falla:

1. Verifica la conexión a internet
2. Revisa las credenciales de Supabase
3. Consulta los logs de debug en la consola

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia

Este proyecto es privado y está destinado solo para uso interno.
