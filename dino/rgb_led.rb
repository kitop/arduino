require 'dino'

board = Dino::Board.new(Dino::TxRx::Serial.new)
led = Dino::Components::RgbLed.new(pins: { red: 9, green: 10, blue: 11 }, board: board)

__END__
loop do
  %w( blue red yellow white ).each do |color|
    puts color
    led.send(color)
    sleep(1)
  end
end
