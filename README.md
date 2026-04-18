# RavenChallenge — NYT Most Popular Articles

Una aplicación iOS de prueba técnica construida en **SwiftUI**, utilizando **MVVM + Clean Architecture** y principios **SOLID**. Consume la API de *Most Popular Articles* del New York Times, mostrando los artículos más leídos con soporte offline y un diseño editorial oscuro inspirado en medios de comunicación de referencia.

---

## 🔧 Tecnologías

| Tecnología | Detalle |
|------------|---------|
| Swift 5.9+ | Concurrencia con `async/await`, `@MainActor`, Swift 6 |
| SwiftUI (iOS 17+) | `NavigationStack`, `ScrollView`, `ShareLink` |
| MVVM + Clean Architecture | Domain / Data / Presentation |
| XCTest & Swift Testing | Pruebas unitarias sin dependencias externas |
| `URLSession` | Cliente HTTP genérico, sin terceros |
| `FileManager` + JSON | Persistencia offline |
| `SFSafariViewController` | Lectura del artículo completo in-app |

---

## ✅ Funcionalidades

* [x] Lista de artículos más populares (Most Viewed)
* [x] Selector de período: últimas 24 h / esta semana / este mes
* [x] Recarga automática al cambiar período
* [x] Pull-to-refresh
* [x] Vista de detalle editorial con imagen hero, sección, título, autor y abstract
* [x] Apertura del artículo completo en Safari in-app
* [x] Persistencia offline — artículos guardados localmente con `FileManager` + JSON
* [x] Banner de aviso cuando se muestran datos en caché (sin conexión)
* [x] Manejo de errores de red con pantalla de reintento
* [x] Diseño editorial oscuro con tipografía serif
* [x] Previews con `#Preview` en todas las vistas
* [x] Pruebas unitarias para ViewModel y Use Cases

---

## 🎨 Diseño

La app sigue una estética editorial oscura con los siguientes principios:

**Lista de artículos**
- Masthead "THE NEW YORK TIMES" con selector de período por pestañas
- Filas con imagen thumbnail, sección coloreada, título serif y metadata

---

## 🌐 API Utilizada

La app consume la **Most Popular Articles API** del New York Times.

**Endpoint base:**
```
https://api.nytimes.com/svc/mostpopular/v2
```

**Paths disponibles:**

| Path | Descripción |
|------|-------------|
| `/viewed/{period}.json` | Artículos más vistos |
| `/shared/{period}.json` | Artículos más compartidos |
| `/emailed/{period}.json` | Artículos más enviados por e-mail |

**Períodos válidos:** `1`, `7`, `30` (días)

**Ejemplo:**
```
https://api.nytimes.com/svc/mostpopular/v2/viewed/7.json?api-key=<API_KEY>
```

**Documentación oficial:** https://developer.nytimes.com/docs/most-popular-product/1/overview

---

## 📂 Estructura del Proyecto

```
RavenChallenge/
├── Core/
│   ├── Networking/
│   │   ├── NetworkService.swift         # Cliente HTTP genérico (URLSession + async/await)
│   │   ├── NetworkError.swift           # Errores tipados (noInternet, serverError, etc.)
│   │   └── APIEndpoint.swift            # Construcción de URLs por endpoint
│   └── Extensions/
│       └── Color+Hex.swift              # Inicializador Color(hex:)
├── Features/
│   └── MostPopular/
│       ├── Domain/                      # Swift puro — sin imports de frameworks UI
│       │   ├── Entities/
│       │   │   └── Article.swift        # Modelo de dominio: Identifiable, Codable, Sendable
│       │   ├── Repositories/
│       │   │   └── ArticleRepositoryProtocol.swift
│       │   └── UseCases/
│       │       └── FetchMostPopularArticlesUseCase.swift
│       ├── Data/
│       │   ├── DTOs/
│       │   │   └── ArticleResponseDTO.swift   # Decodable + toDomain()
│       │   ├── Persistence/
│       │   │   └── ArticleLocalStorage.swift  # FileManager + JSONEncoder
│       │   └── Repositories/
│       │       └── ArticleRepositoryImpl.swift # Network-first, fallback a caché
│       ├── Presentation/
│       │   ├── Theme/
│       │   │   └── AppTheme.swift       # Paleta, tipografía, espaciados
│       │   ├── ViewModels/
│       │   │   ├── ArticleListViewModel.swift  # @MainActor, Combine, LoadingState
│       │   │   └── ArticleDetailViewModel.swift
│       │   └── Views/
│       │       ├── ArticleListView.swift
│       │       ├── ArticleDetailView.swift
│       │       ├── ArticleRowView.swift
│       │       ├── NewsImageView.swift
│       │       └── PreviewHelpers.swift  # Mocks para Xcode Previews (#if DEBUG)
│       └── DI/
│           └── MostPopularAssembly.swift # Factory que ensambla el grafo de dependencias
└── RavenChallengeApp.swift

RavenChallengeTests/
├── Mocks/
│   ├── MockArticleRepository.swift
│   └── MockFetchUseCase.swift
├── UseCases/
│   └── FetchMostPopularArticlesUseCaseTests.swift
├── ViewModels/
│   └── ArticleListViewModelTests.swift
└── RavenChallengeTests.swift
```

---

## 🏛️ Arquitectura

Se eligió **MVVM + Clean Architecture** por las siguientes razones:

- **Separación de responsabilidades** — cada capa tiene una única función (Domain, Data, Presentation).
- **Testabilidad** — Use Cases y ViewModels dependen de protocolos, reemplazables con mocks.
- **Escalabilidad** — agregar nuevos endpoints (emailed, shared) no requiere modificar capas existentes.
- **Sin acoplamiento con frameworks** — la capa Domain es Swift puro, sin imports de UIKit/SwiftUI.

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation                        │
│   ArticleListView ──▶ ArticleListViewModel              │
│   ArticleDetailView ──▶ ArticleDetailViewModel          │
└────────────────────────┬────────────────────────────────┘
                         │ depende de protocolos
┌────────────────────────▼────────────────────────────────┐
│                       Domain                            │
│   FetchMostPopularArticlesUseCase                       │
│   ArticleRepositoryProtocol                             │
│   Article (Entity)                                      │
└────────────────────────┬────────────────────────────────┘
                         │ implementa protocolos
┌────────────────────────▼────────────────────────────────┐
│                        Data                             │
│   ArticleRepositoryImpl                                 │
│   NetworkService  ──▶  ArticleResponseDTO               │
│   ArticleLocalStorage (FileManager + JSON)              │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 Pruebas Unitarias

| Suite | Casos cubiertos |
|-------|----------------|
| `ArticleListViewModelTests` | Estado inicial · carga exitosa · error de red · fallback a caché · sin caché offline · cambio de período · retry |
| `FetchMostPopularArticlesUseCaseTests` | Períodos válidos (1/7/30) · período inválido · propagación de errores · mapeo de resultados |
| `RavenChallengeTests` | Helpers del entity (`cleanByline`, `sectionUppercased`, `formattedDate`) |

---

## 👨‍💻 Autor

**Jonathan López**
> iOS Developer · Swift · SwiftUI · Clean Architecture

---

🏗️ Proyecto desarrollado como prueba técnica para **Raven** (2025).
