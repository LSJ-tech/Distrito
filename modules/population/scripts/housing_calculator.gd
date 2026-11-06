class_name HousingCalculator
extends RefCounted

## Determina crecimiento y demanda de vivienda de forma agregada (no por
## ciudadano individual). Clase auxiliar, propiedad de PopulationManager.
## La capacidad total se seguirá de forma incremental en PopulationManager
## (vía EventBus.building_placed/demolished), no recalculada desde una lista
## completa de edificios en cada consulta.

## Fracción del cupo libre que se ocupa en cada tick (crecimiento gradual,
## nunca instantáneo).
const GROWTH_RATE: float = 0.1


func calculate_growth(capacity: int, population: int) -> int:
	var gap := capacity - population
	if gap <= 0:
		return 0
	return maxi(1, ceili(gap * GROWTH_RATE))


func calculate_demand(capacity: int, population: int) -> int:
	return maxi(0, capacity - population)
