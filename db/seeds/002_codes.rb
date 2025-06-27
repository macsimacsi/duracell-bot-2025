def import_codes_from_excel(file_path, temp_path)
  FileUtils.mkdir_p(temp_path) unless File.directory?(temp_path)

  Dir.glob("#{file_path}/*") do |file|
    cat_name = File.basename(file).upcase
    next unless File.directory?(file)

    cat = Category.find_or_create_by(name: cat_name) { puts "Creando la categoria: #{cat_name}" }
    Dir.glob("#{file}/*.csv") do |file3|
      next unless File.file?(file3)

      csv_file_path = temp_path.join([cat.id, File.basename(file3).to_s].join('_'))

      time = Benchmark.realtime do
        next if File.exist?(csv_file_path)

        products = {}
        CSV.open(csv_file_path, 'wb') do |csv|
          CSV.foreach(file3, headers: true) do |row|
            type = row['Tipo']&.strip&.upcase || row['tipo']&.strip&.upcase
            qty = type.split('-').last.to_i
            prod_name = row['Presentacion']&.strip&.upcase || row['presentacion']&.strip&.upcase
            product = products["#{cat.id}#{prod_name}"]
            if product.blank?
              product = Product.find_or_create_by(name: "#{prod_name}-#{qty}", category_id: cat.id) do |prod|
                prod.category = cat
                prod.active = true
                puts "Creando el producto: #{prod.name}"
              end
              unless product.valid?
                raise "No se puede crear producto: #{product.errors.full_messages}, params: #{row.to_h}"
              end

              products["#{cat.id}#{prod_name}"] = product
            end
            code = row['Codigo_cigarrillos_box'].to_s.gsub(/\D/, '').presence
            code ||= row['Codigo_cigarrillos'].to_s.gsub(/\D/, '').presence
            current_timestamp = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
            next if code.blank?

            csv << [product.id, code, current_timestamp, current_timestamp]
          end
        end
      end

      puts "Tiempo: #{time} (#{csv_file_path})"

    end

  end
end

def import_codes_from_csv(file_path)
  table_name = 'codes'
  Dir.glob("#{file_path}/*.csv") do |file|
    next unless File.file?(file)

    begin
      puts "Cargando datos desde #{file} a la tabla #{table_name}..."

      time = Benchmark.realtime do
        ActiveRecord::Base.connection.execute(<<~SQL.squish)
          SET work_mem = '256MB';
          CREATE UNLOGGED TABLE staging_codes (product_id INTEGER, value TEXT, created_at timestamp, updated_at timestamp);
          COPY staging_codes (product_id, value, created_at, updated_at) FROM '#{file}' DELIMITER ',' CSV;
          INSERT INTO #{table_name} (product_id, value, created_at, updated_at)
          SELECT product_id, value, created_at, updated_at FROM staging_codes
          ON CONFLICT (value) DO NOTHING;
          DROP TABLE staging_codes;
          RESET work_mem;
        SQL

        puts 'Datos cargados exitosamente.'
      rescue StandardError => e
        puts "Error al cargar los datos: #{e.message}"
      end

      puts "Tiempo de carga: #{time} (#{file})"
    end
  end

end

if ENV['DATA'] == 'init'
  time = Benchmark.realtime do
    temp = Pathname.new('/tmp/kentucky-codes-new')
    import_codes_from_excel(Rails.root.join('db/seeds/codes'), temp) unless ENV['SKIP_EXCEL'] == 'true'
    import_codes_from_csv(temp)
  end
  puts "Tiempo total: #{time}"
  # Delete temp files
end