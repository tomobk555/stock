#!/usr/bin/ruby
# coding: utf-8

require 'rubygems'
require 'jpstock'
require "io/console"

#stock code

begin

stocks = ARGV[0]
stock = JpStock.price(:code => stocks )
name = JpStock.sector(:code => stocks )

view_thread = Thread.new do
  loop do
   print "\033[2K\r#{name.company_name}"
   sleep 1
    print "\033[2K\r#{stock.open}## Opening Price!! ##"
   sleep 1
   print "\033[2K\r#{stock.close}## Current Price!! ##"
   sleep 1
  end
end


input_thread = Thread.new do
  while STDIN.getch != "q"; end
  puts
  view_thread.kill
end

view_thread.join
input_thread.join

rescue => e

puts "Please assign correct code !!"

end
