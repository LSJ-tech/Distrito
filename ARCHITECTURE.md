# DISTRITO — Arquitectura y convenciones

Estudio: DEVQUAD GAMES. Motor: Godot 4.3+ (fijar y documentar aquí la versión
exacta instalada antes de tocar `TileMapLayer`, cuya API cambió entre 4.0-4.2
y 4.3+). Lenguaje: GDScript. Este documento complementa el plan técnico de
Etapa 1 y registra las decisiones de arquitectura y sus porqués, para que
cualquier cambio futuro (humano o IA) se revise contra esto.

## Patrón general

Managers por módulo (autoload) + EventBus central (autoload) + Resources
tipados para datos de configuración. Comunicación unidireccional:

- Cada módulo con estado persistente tiene **un único manager autoload**:
  `GridManager`, `BuildingManager`, `TransportManager`, `PopulationManager`,
  `EconomyManager`, `ServicesManager`, `CityEventsManager`, además de los
  transversales `EventBus`, `GameState`, `SimulationManager`, `SaveManager`.
- Los managers nunca se referencian entre sí por nodo. Toda comunicación
  cruzada pasa por `EventBus`, con señales declaradas una por una y tipadas
  (nunca un `emit(event_name: String, payload: Dictionary)` genérico).
- Los edificios se definen como `Resource` (`BuildingData` + 4 subclases por
  categoría de zonificación). Agregar un edificio = crear un `.tres`, nunca
  tocar código.
- El modelo de datos del mundo (`GridManager` + `CellData`) es la única
  fuente de verdad; la capa visual (`TileMapLayer`, nodos de edificio) se
  pinta a partir de él y nunca al revés.
- Cada manager que participa del guardado implementa el contrato
  `get_save_data() -> Dictionary` / `load_save_data(data: Dictionary) -> void`.
  El save serializa edificios por `id` de `BuildingData` + estado runtime,
  nunca el Resource completo, para no romper partidas si `BuildingData`
  cambia de forma en el futuro (`SaveData.save_version`).
- Helpers de un módulo que no necesitan ser globales (`ConnectivityGraph`,
  `TrafficSimulator`, `HousingCalculator`, `TaxCalculator`, `Budget`,
  `CoverageCalculator`, `EmergencyDispatcher`, `MissionManager`) son clases
  `RefCounted` con `class_name`, instanciadas y poseídas por el manager
  autoload de su módulo. No son autoload propios.

## Decisión documentada: `class_name` en scripts de autoload

Los scripts registrados como autoload (`EventBus`, `GridManager`,
`BuildingManager`, etc.) **no** declaran `class_name` igual a su nombre de
autoload. Godot ya expone ese nombre como singleton global al registrarlo en
`[autoload]`; declarar además `class_name GridManager` en ese mismo script
produce un choque de identificador global ("ya existe una clase con ese
nombre"). Por eso los managers se referencian siempre por su nombre de
autoload (`GridManager.get_cell(...)`), y `class_name` se reserva para las
clases de datos (`BuildingData` y subclases, `CellData`, `SaveData`) y para
los helpers no-autoload listados arriba, donde sí aporta tipado estático sin
chocar con nada.

## Restricciones de diseño explícitas (no "mejorar" sin revisión)

- **Población agregada**: sin simulación de ciudadanos individuales ni rutas
  por agente. Solo números agregados por zona/distrito.
- **Tráfico simplificado**: sin pathfinding de vehículos individuales. Carga
  de tráfico como un valor 0-1 por tramo de carretera (`TrafficSimulator`).
- **Sin multijugador.**

## Riesgos activos a vigilar

- Recalcular cobertura/conectividad debe ser *event-driven* (al construir,
  demoler, agregar/quitar carretera), nunca en `_process()` por frame.
- Si `EventBus` supera ~40-50 señales, dividir en buses por dominio
  (`ConstructionEvents`, `EconomyEvents`, etc.) — revisar en Etapa 5-6.
