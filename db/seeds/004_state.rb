states = [
  "Asunción",
  "Concepción",
  "San Pedro",
  "Cordillera",
  "Guairá",
  "Caaguazú",
  "Caazapá",
  "Itapúa",
  "Misiones",
  "Paraguarí",
  "Alto Paraná",
  "Central",
  "Ñeembucú",
  "Amambay",
  "Canindeyú",
  "Presidente Hayes",
  "Boquerón",
  "Alto Paraguay"
]

states.each_with_index do |name, index|
  State.find_or_create_by(id: index + 1) do |state|
    state.name = name
  end
end
