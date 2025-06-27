namespace :codes do
  desc 'Update and create codes, products and categories from CSV files'
  task update_from_csv: :environment do
    CodeProcessor.new.process
  end
end

class CodeProcessor
  BATCH_SIZE = 1000

  def initialize
    @log_path = Rails.root.join('log', 'rake_codes.log')
    @base_dir = Rails.root.join('db/seeds')
    @summary = Hash.new { |h, k| h[k] = { update: 0, create: 0 } }
    @counter = 0
    @new_codes = []
    @updates = []
    setup_logging
  end

  def process
    total_time = Benchmark.realtime do
      preload_catalog!
      ActiveRecord::Base.logger.silence do
        process_files
        perform_final_updates
      end
    end
    log_summary(total_time)
  end

  private

  def setup_logging
    File.open(@log_path, 'w') {}
  end

  def process_files
    csv_files.each do |path|
      puts "🔄 Procesando archivo: #{path}"
      process_file(path)
      move_processed_file(path)
    end
  end

  def csv_files
    Dir.glob("#{@base_dir}/codes/**/*.csv")
  end

  def process_file(path)
    log_message("📁 Procesando archivo: #{path}")
    @existing_codes = preload_existing_codes(path)

    buffer = []
    seen = Set.new
    duplicates = Set.new

    CSV.foreach(path, headers: true) do |row|
      code = extract_code(row)
      duplicates << code if code.present? && !seen.add?(code)
      buffer << row

      if buffer.size >= 1000
        buffer.each { |r| process_row(r) }
        flush_batches(path) if should_flush_batches?
        buffer.clear
      end
    end

    # Procesar el resto
    buffer.each { |r| process_row(r) }
    flush_batches(path)

    log_duplicates(duplicates, path)
  end

  def extract_codes_from_csv(path)
    codes = Set.new
    CSV.foreach(path, headers: true) do |row|
      code = extract_code(row)
      codes << code if code.present?
    end
    codes
  end

  def preload_existing_codes(path)
    codes = extract_codes_from_csv(path)
    Code.where(value: codes.to_a).pluck(:value, :product_id).to_h
  end

  def preload_catalog!
    @categories = Category.all.index_by(&:name)
    @products = Product.all.group_by { |p| [p.name, p.category_id] }
  end

  def process_row(row)
    code = extract_code(row)
    return unless code.present?

    type, presentation = extract_type_and_presentation(row)
    return unless type.present? && presentation.present?

    split_type = type.split('-')
    category = split_type.first.upcase
    variant = split_type.last.upcase
    product = "#{presentation}-#{variant}"
    process_code(code, category, product)
  end

  def extract_code(row)
    row['Codigo_cigarrillos_box'].to_s.gsub(/\D/, '').presence ||
      row['Codigo_cigarrillos'].to_s.gsub(/\D/, '').presence
  end

  def extract_type_and_presentation(row)
    [
      row['Tipo']&.strip&.upcase || row['tipo']&.strip&.upcase,
      row['Presentacion']&.strip&.upcase || row['presentacion']&.strip&.upcase
    ]
  end

  def process_code(code, category_name, product_name)
    category = find_or_create_category(category_name)
    product = find_product(category, product_name)
    handle_code(code, product)
  end

  def find_or_create_category(category_name)
    @categories[category_name] ||= Category.create!(name: category_name)
  end

  def find_product(category, product_name)
    key = [product_name, category.id]
    existing = @products[key]&.first
    return existing if existing.present?

    new_product = Product.create!(name: product_name, category_id: category.id, active: true)
    @products[key] = [new_product]
    new_product
  end

  def handle_code(code, product)
    product_id = @existing_codes[code]

    if product_id.present?
      if product_id == product.id
        log_message("⏭️ Código #{code} ya está correctamente asociado. Se saltea.")

        return
      else
        @updates << [code, product.id]
        @summary[product.name][:update] += 1
      end
    else
      @new_codes << {
        value: code,
        product_id: product.id,
        used: false,
        created_at: Time.now,
        updated_at: Time.now
      }
      @summary[product.name][:create] += 1
    end
  end

  def should_flush_batches?
    @updates.size >= BATCH_SIZE || @new_codes.size >= BATCH_SIZE
  end

  def flush_batches(path)
    Code.insert_all(@new_codes) if @new_codes.any?
    update_records(@updates, path) if @updates.any?
    @new_codes.clear
    @updates.clear
    @counter += 1
  end

  def perform_final_updates
    flush_batches('FINAL')
  end

  def update_records(updates, path)
    return if updates.empty?

    sql = 'UPDATE codes SET product_id = data_table.product_id FROM (VALUES '
    sql += updates.map { |id, product_id| "('#{id}', #{product_id})" }.join(',')
    sql += ') AS data_table(id, product_id) WHERE codes.value = data_table.id'

    log_message("🟡 Ejecutando batch con #{updates.size} updates del archivo #{path}")
    ActiveRecord::Base.connection.execute(sql)
    log_message("🟢 Batch ejecutado correctamente del archivo #{path}")
    log_message("📌 Actualizando #{updates.size} códigos del archivo #{path}...")
    log_message("🟢 Actualización de códigos finalizada para #{path}")
    log_message("👌 Total de códigos creados en este batch: #{@new_codes.size}")
  end

  def log_duplicates(duplicates, source_file)
    return if duplicates.empty?

    filename = File.basename(source_file, '.*')
    output_path = Rails.root.join("log", "duplicados_#{filename}.txt")

    File.open(output_path, 'w') do |f|
      f.puts "⚠️ Códigos duplicados detectados en el archivo: #{filename}"
      duplicates.each { |code| f.puts code }
    end

    log_message("⚠️ Se encontraron #{duplicates.size} códigos duplicados en #{filename}")
    log_message("📝 Guardado en: #{output_path}")
  end

  def log_message(message)
    File.open(@log_path, 'a') { |f| f.puts message }
  end

  def log_summary(total_time)
    File.open(@log_path, 'a') do |f|
      f.puts "✅ Finalizado en #{total_time.round(2)} segundos."
      f.puts '📊 Resumen:'
      @summary.each { |product_name, count| f.puts "- #{product_name}: #{count}" }
    end
  end

  def move_processed_file(path)
    processed_dir = Rails.root.join('db/seeds/processed')
    processed_dir = Rails.root.join('db/seeds/processed')
    FileUtils.mkdir_p(processed_dir) unless Dir.exist?(processed_dir)

    filename = File.basename(path)
    new_path = File.join(processed_dir, filename)

    if File.exist?(new_path)
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      filename = "#{File.basename(filename, '.*')}_#{timestamp}#{File.extname(filename)}"
      new_path = File.join(processed_dir, filename)
    end

    FileUtils.mv(path, new_path)
    log_message("📦 Archivo movido a: #{new_path}")
  end
end
