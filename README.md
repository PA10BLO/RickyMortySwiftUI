Aplicación iOS desarrollada con SwiftUI que consume la [API pública de Rick & Morty](https://rickandmortyapi.com/) para mostrar un directorio de personajes con búsqueda, paginación e información detallada de cada uno.

## Características principales

- **Listado con búsqueda y paginación incremental**: la vista principal muestra los personajes en una lista filtrable por nombre, con carga progresiva de páginas adicionales y estados de carga/errores gestionados automáticamente.
- **Detalle enriquecido del personaje**: la pantalla de detalle incluye la imagen, estado vital, especie, género, origen, localización actual y episodios en los que aparece el personaje.
- **Información contextual de localizaciones y residentes**: cada localización muestra información adicional obtenida bajo demanda y una fila navegable con los residentes disponibles.
- **Manejo de estados vacíos y errores**: la interfaz incorpora componentes reutilizables para comunicar resultados vacíos y errores con opción de reintento.

## Arquitectura

El proyecto sigue una arquitectura basada en **MVVM** apoyada en las nuevas anotaciones `@Observable` de Swift 5.9/iOS 17. Cada escena dispone de un `ViewModel` responsable de la lógica de negocio y del acceso a la capa de datos, mientras que las vistas SwiftUI se encargan de la renderización declarativa.

La capa de datos se organiza mediante un repositorio que abstrae las llamadas HTTP y centraliza la composición de URLs hacia la API. Las peticiones utilizan `async/await`, gestionan estados de error específicos y soportan la descarga de recursos relacionados (personajes, localizaciones, episodios).

## Dependencias y tecnologías

- SwiftUI y Observation framework (`@Observable`) para la UI reactiva.
- URLSession con `async/await` para la comunicación de red.
- Localización mediante extensiones de `String` y `NSLocalizedString`.

No se utilizan librerías de terceros; todo el código es Swift puro.

## Requisitos previos

- macOS con Xcode 15 o superior.
- iOS 17 como versión mínima de despliegue (requerido por `@Observable`).
- Conexión a Internet para consultar la API.

## Ejecución

1. Clona el repositorio y abre el archivo `RickyMortySwiftUI.xcodeproj` en Xcode.
2. Selecciona el esquema `RickyMortySwiftUI` y un simulador o dispositivo con iOS 17 o superior.
3. Presiona **⌘R** para compilar y lanzar la aplicación.

## Pruebas automatizadas

El proyecto incluye pruebas unitarias centradas en la lógica de paginación, búsqueda y manejo de errores del `MainViewModel`, utilizando XCTest y repositorios simulados.

Para ejecutarlas desde la terminal:

```bash
xcodebuild test \
  -project RickyMortySwiftUI.xcodeproj \
  -scheme RickyMortySwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

O bien desde Xcode con **⌘U** sobre el esquema de la app.

## Estructura del proyecto

```
RickyMortySwiftUI/
├── RickyMortySwiftUI/              # Código fuente de la app
│   ├── Source/
│   │   ├── Models/                 # Modelos decodificables y tipado de personajes
│   │   ├── Scenes/                 # Vistas y ViewModels (Main y detalle)
│   │   ├── Services/               # Capa de red y repositorios
│   │   └── Utils/                  # Componentes reutilizables y constantes
│   └── RickyMortySwiftUITests/     # Pruebas unitarias
└── README.md
```

## Internacionalización

La interfaz utiliza claves localizadas para soportar distintos idiomas, centralizadas mediante una extensión de `String`. Añade las traducciones pertinentes en los ficheros `.strings` para ampliar la cobertura de idiomas.

## Próximos pasos sugeridos

- Añadir más cobertura de pruebas para la vista de detalle y la carga de residentes.
- Incorporar almacenamiento en caché o persistencia ligera para mejorar la experiencia offline.
- Exponer capturas de pantalla y un flujo de integración continua.
