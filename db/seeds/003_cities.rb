# # frozen_string_literal: true

# file_path = Rails.root.join('db/seeds/assets/cities.json')

# if File.exist?(file_path)
#   states = {}
#   cities = JSON.parse(File.read(file_path))
#   cities.each do |city|
#     state = states[city['state_id']]
#     if state.blank?
#       state = State.find_or_create_by(name: city['state']) do
#         puts "Creando el departamento '#{city['state']}'"
#       end
#       raise "El departamento '#{city['state']}' no pudo ser creado" unless state.valid?

#       states[city['state_id']] = state
#     end

#     City.find_or_create_by(name: city['city'], state_id: state.id) do |c|
#       c.name = city['city']
#       c.active = true
#       puts "Creando la ciudad '#{city['city']}'"
#     end
#   end

# end
