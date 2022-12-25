module Advent::Day24

  def self.run
    data = Advent.input(day: 24, title: "Blizzard Basin").lines.map(&.chomp)

    phases = parse(data)
    valley_entrance = {data.first.index('.').not_nil!, 0}
    valley_exit = {data.last.index('.').not_nil!, data.size - 1}

    time = find_path(phases, 0, valley_entrance, valley_exit)
    Advent.answer(part: 1, answer: time)

    time = find_path(phases, time, valley_exit, valley_entrance)
    time = find_path(phases, time, valley_entrance, valley_exit)
    Advent.answer(part: 2, answer: time)
  end

  def self.parse(valley)
    empty_valley = valley.map { |line| line.gsub(/[><v^]/, ".") }
    iwidth = valley[0].size - 2
    iheight = valley.size - 2

    # General all possible phases
    phase_count = iwidth.lcm(iheight)
    phases = phase_count.times.map { empty_valley.map(&.dup) }.to_a
    valley.size.times do |y|
      valley[y].size.times do |x|
        case valley[y][x]
        when 'v' then path = ->(time : Int32) { [x, 1 + (y - 1 + time) % iheight] }
        when '^' then path = ->(time : Int32) { [x, 1 + (y - 1 - time) % iheight] }
        when '>' then path = ->(time : Int32) { [1 + (x - 1 + time) % iwidth, y] }
        when '<' then path = ->(time : Int32) { [1 + (x - 1 - time) % iwidth, y] }
        else next
        end

        phases.each_with_index do |phase, time|
          px, py = path.call(time)
          phase[py] = phase[py].sub(px, 'B')
        end
      end
    end
    phases.to_a
  end

  def self.possible_next_coords(phases, time, coords : {Int32, Int32})
    phase = phases[(time+1) % phases.size]
    x, y = coords
    candidates = [{x, y}, {x+1, y}, {x-1, y}, {x, y+1}, {x, y-1}]
    candidates.select { |cx, cy| (phase[cy]? || "")[cx]? == '.' }
  end

  def self.find_path(phases, time : Int32, start : {Int32, Int32}, goal : {Int32, Int32})
    frontier = [start]
    loop do
      new_frontier = Set({Int32, Int32}).new
      return time if frontier.includes?(goal)
      frontier.each do |coords|
        new_frontier += Set({Int32, Int32}).new(possible_next_coords(phases, time, coords))
      end
      time += 1
      frontier = new_frontier
    end
  end
end
