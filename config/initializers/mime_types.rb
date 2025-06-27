# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register "application/pdf", :pdf
Mime::Type.register "application/xlsx", :xlsx
# Register common media MIME types
Mime::Type.register 'image/jpeg', :jpeg
Mime::Type.register 'image/jpg', :jpg
Mime::Type.register 'image/png', :png
Mime::Type.register 'image/gif', :gif
Mime::Type.register 'image/tiff', :tiff
Mime::Type.register 'image/bmp', :bmp
Mime::Type.register 'image/webp', :webp
Mime::Type.register 'image/svg+xml', :svg

Mime::Type.register 'audio/mpeg', :mp3
Mime::Type.register 'audio/wav', :wav
Mime::Type.register 'audio/ogg', :ogg

Mime::Type.register 'video/mp4', :mp4
Mime::Type.register 'video/quicktime', :mov
Mime::Type.register 'video/webm', :webm

