require 'net/ping'

class Pinger
  def ping(line)
    return unless line.hostname || line.address
    line.log = line.log.slice(0, 14)
    pe = Net::Ping::External.new(line.address || line.hostname)
    start = Time.now
    line.res = pe.ping
    line.rtt = Time.now - start
    line.loss = (line.snt * line.loss + (line.res ? 0 : 1)) / (line.snt + 1).to_f
    line.avg = (line.snt * line.avg + line.rtt) / (line.snt + 1).to_f if line.res
    line.snt += 1
    line.log.unshift line.res
  end
end
