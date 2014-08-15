require 'artoo'
require 'artoo-arduino'

connection :arduino, adaptor: :firmata, port: '/dev/tty.usbserial-A600ezfM'
device :led0, driver: :led, pin: 10
device :led1, driver: :led, pin: 11
device :led2, driver: :led, pin: 12

work do
  [:on, :off].each do |state|
    [led0, led1, led2].each do |led|
      led.send(state)
      sleep 0.5
    end
  end
end
