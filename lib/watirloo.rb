$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'watirloo/watir_ducktape'
require 'watirloo/watir_reflector'
require 'watirloo/firewatir_ducktape'
require 'watirloo/page'
require 'watirloo/usecase'

module Watirloo
  VERSION = '0.0.4' # Feb2009
end