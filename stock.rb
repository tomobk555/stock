#!/usr/bin/ruby
# coding: utf-8

require 'rubygems'
require 'jpstock'
require 'io/console'
require 'curses'
require 'holiday_japan'

include Curses

class Date
  def business_days(i)
    date = self
    i.times.each do |j|
      date -= 1
      date -= 1 while (date.wday <= 0 || date.wday >= 6) or (date.national_holiday?)
    end
    date
  end
end


begin

view_thread = Thread.new do

  loop do

#stock code assign

  stocks = ARGV[0]

  stock = JpStock.price(:code => stocks )
  name = JpStock.sector(:code => stocks )

    hstocks = JpStock.historical_prices(
    :code => stocks,
    :start_date => Date.today.business_days(24),
    :end_date => Date.today
    )

  last_day = hstocks[0].close
  this_day = stock.close
  rate = ((this_day - last_day)/last_day * 100).round(2)


   print "\033[2K\r#{name.company_name}"
     sleep 1
   print "\033[2K\r#{stock.open} ## Opening Price!! ##"
     sleep 1
   print "\033[2K\r#{stock.close} ## Current Price!! ##"
     sleep 1
   print "\033[2K\r#{rate}% ## The day before ration!! ##"
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
setpos(0, 0)

end
