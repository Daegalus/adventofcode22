module Advent::Day16
  record Valve, name : String, rate : UInt32, connections : Array(String)

  def self.run
    data = Advent.input(day: 16, title: "Proboscidea Volcanium")

    valves = {} of String => Valve
    data.each_line do |line|
      matchdata = /Valve (?<name>[A-Z]+) has flow rate=(?<rate>\d+); tunnel(?:s)? lead(?:s)? to valve(?:s)? (?<connections>[A-Z, ]+)/.match line
      next unless matchdata
      name = matchdata["name"]
      rate = matchdata["rate"].to_u32
      connections = matchdata["connections"]
      connections = connections.split(",").map(&.strip)
      valves[name] = Valve.new(name, rate, connections)
    end

    current_valve = "AA"
    graph = floyd_warshall(valves)

    worthIt = [] of Valve
    valves.each { |_, valve| worthIt << valve if valve.rate > 0 || valve.name == "AA" }

    bitfield = {} of String => UInt32
    worthIt.each_with_index { |valve, i| bitfield[valve.name] = 1u32 << i }

    start = 0u32
    worthIt.each { |valve| start = bitfield[valve.name] if valve.name == "AA" }

    bitgraphsl = {} of UInt32 => UInt32
    worthIt.each do |valve|
      worthIt.each do |valve2|
        bitgraphsl[bitfield[valve.name] | bitfield[valve2.name]] = graph[valve.name][valve2.name].to_u
      end
    end

    worthbitsl = {} of UInt32 => Tuple(UInt32, UInt32)
    worthIt.each_with_index do |valve, i|
      worthbitsl[i.to_u] = {bitfield[valve.name], valve.rate.to_u}
    end

    part1 = dfs(worthbitsl, bitgraphsl, start, 30, 0, 0, 0, start)

    allpaths = dfspaths(worthbitsl, bitgraphsl, start, 26, 0, 0, 0, start, 0)

    trimpaths = [] of Tuple(Int32, UInt32)
    allpaths.each do |path|
      trimpaths << path if path[0] > part1/2
    end

    part2 = 0u32
    (0..trimpaths.size).each do |i|
      (i + 1..trimpaths.size).each do |j|
        next if j >= trimpaths.size
        next if trimpaths[i][1] & trimpaths[j][1] != 0
        part2 = {part2, trimpaths[i][0] + trimpaths[j][0]}.max
      end
    end

    Advent.answer(part: 1, answer: part1.to_s)
    Advent.answer(part: 2, answer: part2.to_s)
  end

  def self.dfspaths(worthbitsl, bitgraphsl, start, target_time : Int32, pressure : Int32, minute : Int32, on : Int32, node : UInt32, path : UInt32)
    paths = [{pressure, path}]
    worthbitsl.each do |i, bit|
      next if node == bit[0] || bit[0] == start || bit[0] & on != 0
      l = bitgraphsl[node | bit[0]] + 1
      next if minute + l > target_time
      paths += dfspaths(worthbitsl, bitgraphsl, start, target_time, pressure + (target_time - minute - l) * bit[1], minute + l, on | bit[0], bit[0], path | bit[0])
    end
    return paths
  end

  def self.dfs(worthbitsl, bitgraphsl, start, target_time : Int32, pressure : Int32, minute : Int32, on : Int32, node : UInt32)
    max = pressure
    worthbitsl.each do |i, bit|
      next if node === bit[0] || bit[0] == start || bit[0] & on != 0
      l = bitgraphsl[node | bit[0]] + 1
      next if minute + l > target_time
      next_step = dfs(worthbitsl, bitgraphsl, start, target_time, pressure + (target_time - minute - l)*bit[1], minute + l, on | bit[0], bit[0])
      max = {max, next_step}.max
    end
    return max
  end

  def self.vertices(valves : Hash(String, Valve))
    {vertices, dists}
  end

  def self.floyd_warshall(valves : Hash(String, Valve))
    graph = {} of String => Hash(String, Int32)
    valves.each do |name, valve|
      graph[valve.name] = {} of String => Int32
      valves.each do |name2, valve2|
        if name == name2
          graph[name][name2] = 0
        elsif valve.connections.includes?(name2)
          graph[name][name2] = 1
        else
          graph[name][name2] = 0xff
        end
      end
    end

    graph.each do |k, _|
      graph.each do |i, _|
        graph.each do |j, _|
          graph[i][j] = {graph[i][j], graph[i][k] + graph[k][j]}.min
        end
      end
    end

    graph
  end
end
