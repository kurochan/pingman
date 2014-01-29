require 'curses'
require 'socket'

class Screen
  include Curses
  attr_accessor :lines
  public :getch, :close_screen

  TOP_OFFSET = 0
  LETF_OFFSET = 2
  RIGHT_OFFSET = 5
  TIME_LOW = 1
  HOSTNAME_WIDTH = 15
  RESULT_WIDTH = 15
  COL_OFFSET = 3

  def initialize
    init_screen
    start_color
    Curses.init_pair 1, COLOR_WHITE, COLOR_GREEN
    Curses.init_pair 2, COLOR_WHITE, COLOR_RED
    curs_set 0
    noecho
    sleep 0.05
    @lines = []
    @current_cols = cols
    @hostname = Socket.gethostname
    @hostaddr = Socket.getaddrinfo(Socket::gethostname, nil, Socket::AF_INET)[0][3]
    update
  end

  def print_header(line_num)
    title = 'Ping Man'
    setpos(line_num, (cols - title.length) / 2)
    addstr(title)
    line_num += 1

    host = "#{@hostname}(#{@hostaddr})"
    setpos(line_num, LETF_OFFSET)
    addstr(host)
    line_num += 1

    usage = 'Keytype: [a] Display addr, [i] ping interval, [t] ping timeout, [q]uit'
    setpos(line_num, LETF_OFFSET)
    addstr(usage)
    line_num += 1

    line_num += 1

    offset = LETF_OFFSET
    setpos(line_num, offset)
    addstr('HOSTNAME')
    offset += HOSTNAME_WIDTH
    setpos(line_num, offset)
    addstr('ADDRESS')
    offset = cols - RIGHT_OFFSET - RESULT_WIDTH
    setpos(line_num, offset)
    addstr('RESULT')
    offset -= 'SNT'.length + COL_OFFSET
    setpos(line_num, offset)
    addstr('SNT')
    offset -= 'AVG'.length + COL_OFFSET
    setpos(line_num, offset)
    addstr('AVG')
    offset -= 'RTT'.length + COL_OFFSET
    setpos(line_num, offset)
    addstr('RTT')
    offset -= 'LOSS%'.length + COL_OFFSET
    setpos(line_num, offset)
    addstr('LOSS%')
    line_num += 1
  end

  def print_line(line)
    setpos(@lines_low + line.row, 0)
    deleteln
    refresh
    insertln
    attron(A_BLINK) unless line.res
    setpos(@lines_low + line.row, LETF_OFFSET - 2)
    addstr('> ') if line.sending
    offset = LETF_OFFSET
    setpos(@lines_low + line.row, offset)
    addstr(line.hostname.to_s)
    offset += HOSTNAME_WIDTH
    setpos(@lines_low + line.row, offset)
    addstr(line.address.to_s)
    offset = cols - RIGHT_OFFSET - RESULT_WIDTH
    setpos(@lines_low + line.row, offset)
    addstr(line.log.slice(0, 15).map{|c| c ? '.' : '!'}.join)
    offset -= 'SNT'.length + COL_OFFSET
    setpos(@lines_low + line.row, offset + 'SNT'.length - line.snt.to_s.length)
    addstr(line.snt.to_s)
    offset -= 'AVG'.length + COL_OFFSET
    avg = (line.avg * 1000).round.to_s
    setpos(@lines_low + line.row, offset + 'AVG'.length - avg.length)
    addstr(avg)
    offset -= 'RTT'.length + COL_OFFSET
    rtt = (line.rtt * 1000).round.to_s
    setpos(@lines_low + line.row, offset + 'RTT'.length - rtt.length)
    addstr(rtt)
    offset -= 'LOSS%'.length + COL_OFFSET
    loss = "#{sprintf('%.1f',line.loss * 100)}%"
    setpos(@lines_low + line.row, offset + 'LOSS%'.length - loss.length)
    addstr(loss)
    offset -= '   OK   '.length + COL_OFFSET
    setpos(@lines_low + line.row, offset)
    if line.res
      attron(color_pair(1))
      addstr('   OK   ')
    else
      attron(color_pair(2))
      addstr('   NG   ')
    end
    attroff(A_COLOR)
    attroff(A_BLINK)
  end

  def print_lines
    @lines.each do |line|
      print_line line
    end if @lines
  end

  def print_time(line_num)
    time = "[last update #{Time.now.strftime("%m-%d %H:%M:%S")}]"
    setpos(line_num, cols - time.length - RIGHT_OFFSET)
    addstr(time)
    line_num += 1
  end

  def update
    clear
    @lines_low = print_header(TOP_OFFSET)
    print_lines
    refresh
  end

  def update_line(line)
    if @current_cols != cols
      @current_cols = cols
      update
    end
    print_line line
    print_time TIME_LOW
    refresh
  end
end
