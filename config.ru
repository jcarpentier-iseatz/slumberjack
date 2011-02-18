require 'rubygems'
require 'sinatra'
 
disable :run
set :env, :production
set :raise_errors, true
set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'
set :app_file, __FILE__
 
log = File.new("log/slumberjack.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
 
require 'slumberjack.rb'
run Sinatra::Application