require 'artoo'
require 'artoo-arduino'

module Artoo
  # The Artoo::Device class represents the interface to
  # a specific individual hardware devices. Examples would be a digital
  # thermometer connected to an Arduino, or a Sphero's accelerometer.
  class Device
    def require_driver(d, params)
      if Artoo::Robot.test?
        original_type = d
        d = :test
      end

      require "./artoo/drivers/#{d.to_s}"
      @driver = constantize("Artoo::Drivers::#{classify(d.to_s)}").new(:parent => current_instance, :additional_params => params)
    end
  end
end

connection :arduino, :adaptor => :firmata, :port => '/dev/cu.usbserial-A600ezfM'
device :climate, driver: :dht22, pin: 2, interval: 5

work do
  on climate, update: proc { |*data|
    puts "Data: #{data}"
  }
end

