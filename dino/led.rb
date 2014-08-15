require 'dino'

board = Dino::Board.new(Dino::TxRx::Serial.new)
led0 = Dino::Components::Led.new(pin: 10, board: board)
led1 = Dino::Components::Led.new(pin: 11, board: board)
led2 = Dino::Components::Led.new(pin: 12, board: board)

[:on, :off].cycle do |switch|
  led0.send(switch)
  sleep 0.5
  led1.send(switch)
  sleep 0.5
  led2.send(switch)
  sleep 0.5
end
