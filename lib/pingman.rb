require 'pingman/version'
require 'pingman/line'
require 'pingman/screen'
require 'pingman/pinger'
require 'yaml'

module Pingman
  def self.pingman(lines)
    pinger = Pinger.new
    screen = Screen.new
    screen.lines = lines

    Thread.new do
      screen.update
      loop do
        screen.lines.each do |line|
          line.sending = true
          screen.update_line line
          pinger.ping line
          sleep 0.5
          line.sending = false
          screen.update_line line
        end
        sleep 1
      end
    end

    begin
      loop do
        break if screen.getch == 'q'
      end
    ensure
      screen.close_screen
    end
  end
end
