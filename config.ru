$:.unshift File.dirname(__FILE__) + '/lib'
require 'coalman'
require 'coalman/web'

run Coalman::Web