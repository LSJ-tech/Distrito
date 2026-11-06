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

## Decisión documentada: conversión de coordenadas (Etapa 2)

`IsoUtils.grid_to_iso/iso_to_grid` (Etapa 1) es una fórmula isométrica
genérica, sin nodo. Desde que existe un `TileMapLayer` isométrico real
(`TerrainLayer` en `world.tscn`), **la conversión autoritativa es
`TerrainLayer.map_to_local()` / `local_to_map()`** (API nativa de Godot):
garantiza alineación exacta con el `tile_layout`/`tile_size` configurado en
`terrain_tileset.tres`, sin que la fórmula propia pueda desincronizarse del
TileSet si este cambia. Todo código con referencia a `TerrainLayer`
(pintado en `world.gd`, límites de cámara en `camera_controller.gd`,
posicionamiento de edificios en Etapa 3) usa `map_to_local`/`local_to_map`,
no `IsoUtils`. `IsoUtils` se mantiene solo como utilidad de respaldo para
cálculos sin acceso a un nodo `TileMapLayer`.

## Decisión documentada: `tile_set` como dato de escena, no de código

`TerrainLayer`/`RoadLayer` tienen su `tile_set` asignado directamente en
`world.tscn` (propiedad del nodo), no en `world.gd::_ready()`. Es dato
estático, no algo que dependa del modelo (`GridManager`). Asignarlo en
código introdujo un bug real de orden de `_ready()`: `Camera2D` (hermano de
`World` en `main.tscn`) necesitaba `TerrainLayer.map_to_local()` en su
propio `_ready()`, y el orden de `_ready()` entre nodos hermanos no está
garantizado antes de que termine el árbol completo. Con el `tile_set` fijo
en la escena, está disponible desde que el nodo existe, sin depender de
ningún orden de ejecución.

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
