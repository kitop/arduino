module Artoo
  module Drivers
    class Dht22 < Driver

      MAXTIMINGS = 85 # how many timing transitions we need to keep track of. 2 * number bits + extra

      def start_driver
        begin
          connection.digital_write(pin, :high)

          after(interval) do
            puts "DHT ready"
            every interval do
              temperature = read_temperature
              puts temperature
              #update(temperature)
            end
          end
        rescue => e
          puts "Error: #{e}"
        end
      end

      private

      def read_temperature
        data = read
        f = data[2] & 0x7F
        f *= 256
        f += data[3]
        f /= 10
        if (data[2] & 0x80)
          f *= -1
        end
      end

      def read
        laststate = :high
        counter = 0
        j = 0

        data = [0, 0, 0, 0]

        # pull the pin high and wait 250 milliseconds
        connection.digital_write(pin, :high)
        after 0.250 do
          connection.digital_write(pin, :low)
          after 0.020 do
            #noInterrupts()
            digital_write(pin, :high)

            after 0.004 do
              # read in timings
              MAXTIMINGS.each do |i|
                counter = 0
                while (connection.digital_read(pin) == laststate)
                  counter += 1
                  #delayMicroseconds(1)
                  break if (counter == 255)
                end
                laststate = connection.digital_read(pin)

                break if counter == 255

                # ignore first 3 transitions
                if ((i >= 4) && (i%2 == 0))
                  # shove each bit into the storage bytes
                  data[j/8] <<= 1
                  if (counter > _count)
                    data[j/8] |= 1
                  end
                  j += 1
                end
              end
              #interrupts()

              # check we read 40 bits and that the checksum matches
              if (j >= 40) && (data[4] == ((data[0] + data[1] + data[2] + data[3]) & 0xFF))
                return data
              end

              return false
            end
          end
        end

      end

      def update(value)
        event_name = EVENTS[value]
        publish event_topic_name(:update), value
        publish event_topic_name(event_name)
      end

    end
  end
end

