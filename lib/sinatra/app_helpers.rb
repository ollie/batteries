module Sinatra
  module AppHelpers
    def battery_style(battery)
      width = battery.aaa? ? 25 : 40
      "width: #{width}px; background: linear-gradient(to right, rgba(0, 0, 0, 0.2) 0%, rgba(255, 255, 255, 0.3) 40%, rgba(255, 255, 255, 0.3) 60%, rgba(0, 0, 0, 0.2) 100%), #{battery.color};#{' color: white;' if battery.dark}"
    end

    def battery_name_style(battery)
      width = battery.aaa? ? 25 : 40
      "height: #{width}px; line-height: #{width}px;"
    end

    def slot_style(slot)
      width = slot.aaa? ? 25 : 40
      "width: #{width}px;"
    end
  end
end
