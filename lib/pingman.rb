require "pingman/version"

require "pingman/line"
require "pingman/screen"
require "pingman/pinger"

module Pingman
  def self.pingman
    pinger = Pinger.new
    screen = Screen.new

    line = Line.new
    line.hostname = 'local'
    line.address = '127.0.0.1'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'google dns'
    line.address = '8.8.8.8'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'not found'
    line.address = '1.2.3.4'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'google dns'
    line.address = '8.8.4.4'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'google.com'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'yahoo.com'
    line.row = screen.lines.size
    screen.lines.push line
    line = Line.new
    line.hostname = 'microsoft.com'
    line.row = screen.lines.size
    screen.lines.push line

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
