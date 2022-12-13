module Advent::Day12
  def self.adj(y, x, h, w)
    [
      {y - 1, x + 0},
      {y + 0, x - 1},
      {y + 0, x + 1},
      {y + 1, x + 0},
    ].select { |y2, x2| (0 <= y2 < h) && (0 <= x2 < w)}
  end

  def self.run
    puts "[Day 12] Hill Climbing Algorithm"
    data = Advent.input(day: 12)

    grid = data.lines.map(&.chars)
    w = grid[0].size
    h = grid.size

    start_y = grid.index! &.includes?('S')
    start_x = grid[start_y].index! 'S'
    grid[start_y][start_x] = 'a'

    end_y = grid.index! &.includes?('E')
    end_x = grid[end_y].index! 'E'
    grid[start_y][start_x] = 'z'

    answer = traverse(grid, {start_y, start_x}, ending: {end_y, end_x})
    starts = get_a(grid, {end_y, end_x})
    answer2 = starts.map { |y, x| traverse(grid, {end_y, end_x}, ending: {y, x}, part2: true) }.min + 1

    Advent.answer(part: 1, answer: answer.to_s)
    Advent.answer(part: 2, answer: answer2.to_s)
  end

  def self.get_a(grid, start : {Int32, Int32})
    queue = Deque({Int32,Int32}).new([{start[0], start[1]}])
    answer = [] of {Int32, Int32}
    visited = Set({Int32,Int32}).new([start])
    while !queue.empty?
      qy, qx = queue.shift
      adjs = adj(qy, qx, grid.size, grid[0].size)
      adjs = adjs.select{ |dy, dx| grid[dy][dx] - grid[qy][qx] >= -1 }
      adjs = adjs.reject{ |direction| visited.includes? direction }
      adjs.each do |dy, dx|
        if grid[dy][dx] == 'a'
          answer << {dy, dx}
        end
        visited << {dy, dx}
        queue << {dy, dx}
      end
    end
    answer
  end

  def self.traverse(grid, start : {Int32, Int32}, part2 = false, ending = {0,0})
    queue = Deque({Int32,Int32,Int32}).new([{0, start[0], start[1]}])
    answer = 0
    visited = Set({Int32,Int32}).new([start])
    while !queue.empty?
      steps, qy, qx = queue.shift
      adjs = adj(qy, qx, grid.size, grid[0].size)
      adjs = adjs.select{ |dy, dx| grid[dy][dx] - grid[qy][qx] <= 1 } if !part2
      adjs = adjs.select{ |dy, dx| grid[dy][dx] - grid[qy][qx] >= -1 } if part2
      adjs = adjs.reject{ |direction| visited.includes? direction }
      adjs.each do |dy, dx|
        if {dy, dx} == ending
          answer = steps + 1
          break
        end
        visited << {dy, dx}
        queue << {steps + 1, dy, dx}
      end
    end
    answer
  end
end
