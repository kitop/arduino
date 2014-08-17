module Artoo
  module Drivers
    class Hover < Driver

      EVENTS = {
        0b00100010 => :right_swipe,
        0b00100100 => :left_swipe,
        0b00101000 => :up_swipe,
        0b00110000 => :down_swipe,
        0b01001000 => :east_tap,
        0b01000001 => :south_tap,
        0b01000010 => :west_tap,
        0b01000100 => :north_tap,
        0b01010000 => :center_tap
      }

      attr_reader :ts, :reset

      def address
        0x42
      end

      def initialize(params)
        super
        additional_params = params[:additional_params]
        @ts     = additional_params[:ts]
        @reset  = additional_params[:reset]
      end

      def start_driver
        begin
          connection.i2c_start(address)
          connection.set_pin_mode(ts, Firmata::PinModes::INPUT)
          connection.set_pin_mode(reset, Firmata::PinModes::OUTPUT)
          connection.digital_write(reset, :low)
          connection.set_pin_mode(reset, Firmata::PinModes::INPUT)

          after(3) do
            if connection.digital_read(ts)
              connection.digital_write(ts, :low)
              puts "Hover is ready"

              every interval do
                raw_value = connection.i2c_read(18)
                puts raw_value
                new_value = parse(raw_value)
                update(new_value) unless new_value.nil? or new_value.empty?
              end
            else
              puts "Hover not ready"
            end
          end
        rescue => e
          puts "Error: #{e}"
        end
      end

      def release
        connection.digital_write(ts, :high)
        connection.set_pin_mode(ts, Firmata::PinModes::INPUT)
      end

      private

      def parse(raw_value)
        raw_value #[0b00100010]
      end

      def update(value)
        event_name = EVENTS[value]
        publish event_topic_name(:update), value
        publish event_topic_name(event_name)
      end

    end
  end
end
