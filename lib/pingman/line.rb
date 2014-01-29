class Line
  attr_accessor :hostname, :address, :res, :loss, :rtt, :avg, :snt, :log, :sending, :row
  def initialize
    @hostname = nil
    @address = nil
    @res = true
    @loss = 0.0
    @rtt = 0
    @avg = 0
    @snt = 0
    @log = []
    @sending = false
    @row = 0
  end
end
