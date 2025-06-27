class Utils
    require 'rack/mime'


    def self.get_file_extension(mime_type)
        Mime::Type.lookup(mime_type).symbol.to_s
    end
end