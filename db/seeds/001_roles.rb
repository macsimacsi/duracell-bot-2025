role = Role.find_or_create_by(name: 'root')

role.tap do |r|
  Role.columns.each { |c| r[c.name] = true if c.type == :boolean }
  r.save
end

admin = Admin.find_or_create_by(email: "admin@admin.com") do |a|
  a.password = 'Admin.123'
  a.role = role
end
