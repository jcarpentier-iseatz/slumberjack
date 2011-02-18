require 'rubygems'
require 'sinatra'
require 'erb'
require 'postgres'
require 'active_record'

require 'lib/saxe'
require 'lib/dennis_parker'

require 'models'


ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => 'simian_local',
  :host => '127.0.0.1',
  :timeout => '5000'
)

helpers do
  include Rack::Utils
  include Saxe::ViewHelpers
  
  alias_method :h, :escape_html
end

get '/supplier' do
  @page = {:name => :supplier, :base_url => "/supplier"}
  unless params[:id]
    search_options = { :limit => 1 }
    search_options[:offset] = params[:o].to_i if params[:o]
    @supplier_slog = SupplierSlog.find(:all, search_options).first
  else
    @supplier_slog = SupplierSlog.find(params[:id])
  end
  erb :supplier
end

get '/' do
  @page = {:name => :slog, :base_url => "/"}
  unless params[:id]
    search_options = { :limit => 1 }
    search_options[:offset] = params[:o].to_i if params[:o]
    @slog = Slog.find(:all, search_options).first
  else
    @slog = Slog.find(params[:id])
  end
  erb :index
end