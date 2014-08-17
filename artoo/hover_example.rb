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
device :hover, driver: :hover, ts: 5, reset: 6, interval: 0.01

work do
  on hover, :update => proc { |_, event|
    puts "event"
  }
end
