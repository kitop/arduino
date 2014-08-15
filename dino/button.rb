require 'dino'

board = Dino::Board.new(Dino::TxRx::Serial.new)
button = Dino::Components::Button.new(pin: 7, board: board)

led0 = Dino::Components::Led.new(pin: 10, board: board)
led1 = Dino::Components::Led.new(pin: 11, board: board)
led2 = Dino::Components::Led.new(pin: 12, board: board)

states = [:on, :off].cycle

button.up do
  puts "up"

  switch = states.next
  [led0, led1, led2].each do |led|
    led.send(switch)
  end
end

button.down do
  puts "down"
end

sleep
