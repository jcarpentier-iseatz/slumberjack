# Dennis Parker was Frank Sinatra's driver.
# dennis_parker is a url generator for Sinatra.
# They both get Sinatra where Sinatra needs to get.

module Sinatra
  
  def add_route(name, path, klass = nil)
    @route_hash ||= {}
    @route_hash[name] = {:path => path, :klass => klass }
  end
  
  def url_for(object_or_symbol, parameters = {})
    case object_or_symbol.class.to_s
    when "Symbol"
      return build_uri(@route_hash[object_or_symbol][:path], parameters)
    when "String"
      return build_uri(object_or_symbol, parameters)
    else
      @route_hash.each do |key, data|
        if object_or_symbol.class.to_s == data[:klass]
          obj_id = (defined? object_or_symbol.to_param) ? "/#{object_or_symbol.to_param}" : nil
          path = "#{data[:path]}#{obj_id}"
          return build_uri(path, parameters)
        end
      end
    end
    raise "Route for #{object_or_symbol} not found."
  end
  
  
  def build_uri(path, parameters)
    buff = "#{@request.script_name}#{path}#{hash_to_params(parameters)}"
  end
  
  def hash_to_params(opts)
    return nil unless opts.length > 0
    buff = []
    opts.each_pair do |key, data|
      buff << "#{key}=#{data}" if data && !(data.empty?)
    end
    return nil unless buff.length > 0
    "?#{buff.join("&")}"
  end
  
end