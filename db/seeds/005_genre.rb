genres = [
  { name: 'femenino' },
  { name: 'masculino' },
  { name: 'prefiero_no_decir' },
  { name: 'otro' }
]

genres.each do |g|
  Genre.find_or_create_by(name: g[:name])
end
