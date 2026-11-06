class_name TaxCalculator
extends RefCounted

## Calcula ingresos fiscales en función de población y actividad económica.
## Clase auxiliar, propiedad de EconomyManager; sin estado propio persistente
## (recibe los datos que necesita como parámetros, para ser fácil de testear).

func calculate_income(population: int, commercial_tax_revenue: int, tax_rate: float) -> int:
	var residential_income := population * GameConstants.RESIDENTIAL_TAX_PER_CAPITA
	return roundi((residential_income + commercial_tax_revenue) * tax_rate)
