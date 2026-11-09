# NeuroAzul

**NeuroAzul** es una aplicación educativa gamificada desarrollada con Flutter, orientada a apoyar actividades de aprendizaje mediante pictogramas, reconocimiento de emociones y organización de rutinas cotidianas.

El sistema fue desarrollado como proyecto académico de Ingeniería de Software y cuenta con una versión Web pública y una versión Android distribuible mediante APK.

## Acceso a la aplicación

### Versión Web

La aplicación puede utilizarse directamente desde el navegador:

**https://davidarp19-bit.github.io/NeuroAzul/**

No es necesario instalar Flutter, GitHub ni otras herramientas de desarrollo.

### Versión Android

La versión Android se encuentra disponible en la Release:

**NeuroAzul v1.0.0**

Archivo principal:

`NeuroAzul-v1.0.0.apk`

Requisito mínimo:

**Android 7.0 (API 24) o superior.**

---

## Funcionalidades principales

NeuroAzul incluye:

- Registro e inicio de sesión de usuarios adultos.
- Creación y administración de perfiles infantiles.
- Selección de avatar.
- Actividades con pictogramas.
- Actividades para reconocimiento de emociones.
- Rutinas de higiene matutina.
- Rutinas de alimentación.
- Retroalimentación inmediata.
- Sistema de puntos, niveles y recompensas.
- Consulta de logros.
- Seguimiento del progreso.
- Persistencia local mediante SQLite.
- Funcionamiento temporal sin conexión.
- Sincronización posterior con Supabase.

---

## Tecnologías utilizadas

### Frontend

- Flutter 3.47.9
- Dart 3.13.7
- Riverpod
- go_router

### Persistencia local

- Drift 2.35.3
- SQLite
- sqlite3 3.5.2

### Backend

- Supabase Auth
- Supabase PostgreSQL
- Row Level Security (RLS)

### Desarrollo y despliegue

- Git
- GitHub
- GitHub Codespaces
- GitHub Actions
- GitHub Pages

---

## Arquitectura

NeuroAzul utiliza una arquitectura organizada por capas e inspirada en el patrón **MVVM**, complementada mediante el patrón **Repository**.

La estructura general comprende:

```text
Presentación
    ↓
ViewModels / Riverpod
    ↓
Repositories / Services
    ↓
┌───────────────────┬─────────────────────┐
│ Drift / SQLite    │ Supabase            │
│ Persistencia local│ Persistencia remota │
└───────────────────┴─────────────────────┘
```

La navegación se administra mediante `go_router`.

El mecanismo de persistencia local permite almacenar temporalmente información cuando no existe conexión y sincronizar posteriormente los registros pendientes con Supabase.

---

## Estructura general del proyecto

```text
NeuroAzul/
├── .github/
│   └── workflows/
│       ├── build-android-apk.yml
│       └── deploy-web-pages.yml
│
├── neuroazul_app/
│   ├── android/
│   ├── lib/
│   │   ├── core/
│   │   └── features/
│   ├── test/
│   ├── web/
│   └── pubspec.yaml
│
├── supabase/
│   └── migrations/
│       └── 20261109_initial_neuroazul_schema.sql
│
└── README.md
```

---

## Instalación para desarrolladores

### 1. Clonar el repositorio

```bash
git clone https://github.com/davidarp19-bit/NeuroAzul.git
cd NeuroAzul/neuroazul_app
```

### 2. Verificar Flutter

La versión utilizada para el proyecto es:

```text
Flutter 3.47.9 stable
Dart 3.13.7
```

Comprobar la instalación:

```bash
flutter --version
```

### 3. Instalar dependencias

```bash
flutter pub get
```

---

## Configuración de Supabase

Crear el directorio de configuración:

```bash
mkdir -p config
```

Crear el archivo:

```text
config/supabase.json
```

con la siguiente estructura:

```json
{
  "SUPABASE_URL": "URL_DEL_PROYECTO_SUPABASE",
  "SUPABASE_PUBLISHABLE_KEY": "CLAVE_PUBLICA_DEL_PROYECTO"
}
```

Este archivo está excluido del repositorio mediante `.gitignore`.

**No deben almacenarse claves administrativas como `service_role` dentro de la aplicación cliente.**

---

## Base de datos

La estructura necesaria para Supabase se encuentra versionada en:

```text
supabase/migrations/20261109_initial_neuroazul_schema.sql
```

La migración contiene:

- `child_profiles`
- `pictogram_attempts`
- `emotion_attempts`
- `routine_attempts`
- claves primarias y foráneas
- restricciones
- relaciones
- políticas Row Level Security
- privilegios de acceso

Esto permite reconstruir la estructura remota requerida por NeuroAzul en un nuevo proyecto Supabase.

---

## Ejecutar pruebas

NeuroAzul cuenta con **39 pruebas automatizadas**.

Para ejecutarlas:

```bash
flutter test
```

La versión final integrada en la rama `main` registra:

```text
39 pruebas aprobadas
0 pruebas fallidas
```

También puede ejecutarse análisis estático mediante:

```bash
flutter analyze
```

---

## Ejecutar la versión Web

Compilar:

```bash
flutter build web \
  --dart-define-from-file=config/supabase.json
```

Para ejecutar localmente la compilación:

```bash
python3 -m http.server 3000 \
  --bind 0.0.0.0 \
  --directory build/web
```

La versión pública se despliega automáticamente mediante GitHub Actions en:

**https://davidarp19-bit.github.io/NeuroAzul/**

---

## Generación del APK Android

La construcción Android está automatizada mediante:

```text
.github/workflows/build-android-apk.yml
```

El workflow:

1. configura el entorno;
2. instala dependencias;
3. obtiene la configuración mediante GitHub Secrets;
4. ejecuta las pruebas automatizadas;
5. genera el APK de release;
6. calcula la suma SHA-256;
7. publica el resultado como artefacto.

El APK estable se distribuye mediante la Release:

**NeuroAzul v1.0.0**

---

## Despliegue Web

La publicación Web está automatizada mediante:

```text
.github/workflows/deploy-web-pages.yml
```

Cada despliegue desde la rama `main`:

1. ejecuta las pruebas;
2. compila Flutter Web;
3. configura la ruta `/NeuroAzul/`;
4. publica la aplicación mediante GitHub Pages.

---

## Seguridad

NeuroAzul implementa:

- autenticación mediante Supabase Auth;
- Row Level Security en las tablas remotas;
- acceso de cada adulto únicamente a sus perfiles asociados;
- protección de los registros de actividades mediante políticas RLS;
- GitHub Secrets para variables utilizadas durante los procesos de compilación;
- exclusión de archivos locales sensibles mediante `.gitignore`.

---

## Validación

La versión final del sistema cuenta con:

- 39 pruebas automatizadas aprobadas;
- pruebas funcionales sobre los principales módulos;
- prueba de usabilidad con 8 participantes adultos;
- 97,2 % de tareas completadas;
- 93,1 % de tareas realizadas sin ayuda;
- satisfacción general de 4,4/5;
- APK instalado y validado en un dispositivo Android físico;
- versión Web validada mediante acceso público desde navegador.

La evaluación de usabilidad realizada con adultos no constituye una validación directa con niños con TEA.

---

## Alcance

NeuroAzul es un prototipo funcional con fines educativos y académicos.

La aplicación:

- no realiza diagnósticos;
- no determina grados de TEA;
- no reemplaza evaluación profesional;
- no constituye una herramienta clínica o terapéutica.

La validación directa con población infantil se plantea como trabajo futuro y requiere las condiciones metodológicas y éticas correspondientes.

---

## Autores

**Yesica Restrepo**  
**Daniel Pabón**

Proyecto académico de Ingeniería de Software.

---

## Repositorio

**https://github.com/davidarp19-bit/NeuroAzul**

Rama principal:

`main`

## Aplicación Web

**https://davidarp19-bit.github.io/NeuroAzul/**

## Versión estable

**v1.0.0**