module Advent::Day19
  struct Blueprint
    property ore_ore_cost : Int32, clay_ore_cost : Int32, obby_ore_cost : Int32
    property obby_clay_cost : Int32, geode_ore_cost : Int32, geode_obby_cost : Int32

    def initialize(
      @ore_ore_cost, @clay_ore_cost, @obby_ore_cost,
      @obby_clay_cost, @geode_ore_cost, @geode_obby_cost
    )
    end
  end

  class State
    property children = [] of State
    property evaluated = false
    property blueprint : Blueprint
    property time : Int32
    property ore = 0
    property ore_robots = 1
    property clay = 0
    property clay_robots = 0
    property obby = 0
    property obby_robots = 0
    property geode = 0
    property geode_robots = 0
    property log = [] of String

    def score
      ore + clay * 10 + obby * 100 + geode * 10000
    end

    def dup
      new_state = State.new(blueprint, time)
      new_state.ore = ore
      new_state.ore_robots = ore_robots
      new_state.clay = clay
      new_state.clay_robots = clay_robots
      new_state.obby = obby
      new_state.obby_robots = obby_robots
      new_state.geode = geode
      new_state.geode_robots = geode_robots
      new_state.log = log.dup
      return new_state
    end

    def initialize(@blueprint, @time)
    end

    def produce
      @time -= 1
      @ore += @ore_robots
      @clay += @clay_robots
      @obby += @obby_robots
      @geode += @geode_robots
    end

    def step
      return @children if evaluated
      if time > 0
        do_nothing = dup
        do_nothing.produce
        @children << do_nothing

        if ore >= blueprint.ore_ore_cost
          build_ore = dup
          build_ore.ore -= blueprint.ore_ore_cost
          build_ore.produce
          build_ore.ore_robots += 1
          children << build_ore
        end

        if ore >= blueprint.clay_ore_cost
          build_clay = dup
          build_clay.ore -= blueprint.clay_ore_cost
          build_clay.produce
          build_clay.clay_robots += 1
          children << build_clay
        end

        if ore >= blueprint.obby_ore_cost && clay >= blueprint.obby_clay_cost
          build_obby = dup
          build_obby.ore -= blueprint.obby_ore_cost
          build_obby.clay -= blueprint.obby_clay_cost
          build_obby.produce
          build_obby.obby_robots += 1
          children << build_obby
        end

        if ore >= blueprint.geode_ore_cost && obby >= blueprint.geode_obby_cost
          build_geode = dup
          build_geode.ore -= blueprint.geode_ore_cost
          build_geode.obby -= blueprint.geode_obby_cost
          build_geode.produce
          build_geode.geode_robots += 1
          children << build_geode
        end
      else
        @children = [self]
      end
      @evaluated = true
      return @children
    end

    def future_score(depth)
      states = [self]
      depth.times { states = states.flat_map(&.step) }
      states.max_by(&.score).score
    end
  end

  def self.qualities(blueprints : Array(Blueprint), time : Int32, part = 1)
    print "  Long Running Part #{part} |"
    blueprints.map_with_index do |blueprint, i|
      states = [State.new(blueprint, time)]
      print "."
      print "|\n" if i == blueprints.size - 1
      time.times do
        states = states
          .flat_map(&.step)
          .sort_by(&.future_score(3))
          .last(1000) if part == 1
        states = states
          .flat_map(&.step)
          .sort_by(&.future_score(4))
          .last(1000) if part == 2
      end
      part == 1 ? states.map(&.geode).max * (i + 1) : states.map(&.geode).max
    end
  end

  def self.run
    data = Advent.input(day: 19, title: "Not Enough Minerals")

    blueprints = parse(data)
    
    part1 = qualities(blueprints, time: 24, part: 1)
    Advent.answer(part: 1, answer: part1.sum)

    part2 = qualities(blueprints[0..2], time: 32, part: 2)
    Advent.answer(part: 2, answer: part2.product)
  end

  def self.parse(input)
    blueprints = [] of Blueprint
    input.lines.each do |line|
      bpi = line.match(/Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./)
      next if bpi.nil?
      blueprints << Blueprint.new(*({bpi[2], bpi[3], bpi[4], bpi[5], bpi[6], bpi[7]}.map(&.to_i)))
    end
    blueprints
  end
end
