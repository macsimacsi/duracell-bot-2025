productos = %w[AAA AA 9V C D 2031 2025 2016]

productos.each do |g|
  Product.find_or_create_by(name: g) do |p|
    p.active = true
    p.qty = 0
    p.participations_count = 0
    p.active = true
  end
end
