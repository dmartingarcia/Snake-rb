#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gosu'

class Snake
  attr_reader :vel_x, :vel_y, :x, :y, :tail, :size

  MIN_SIZE = 3

  def initialize
    @x = rand(0..WIDTH)
    @y = rand(0..HEIGHT)

    @tail = []

    MIN_SIZE.times do |i|
      x = @x
      y = @y - i
      @tail.push([x, y])
    end

    @vel_x = 0
    @vel_y = 0
  end

  def step
    @x = (@x + @vel_x)
    @y = (@y + @vel_y)
    if (@vel_x != 0) || (@vel_y != 0)
      tail.insert 0, [@x, @y]
      tail.pop
    end
  end

  def size
    tail.size
  end

  def draw
    tail.each_with_index do |elem, index|
      x, y = elem
      if index.zero?
        Gosu.draw_rect(pos_x(x), pos_y(y), TILE_SIZE, TILE_SIZE, color(index))
      else
        Gosu.draw_rect(pos_x(x), pos_y(y), TILE_SIZE, TILE_SIZE, color(index))
      end
    end
  end

  def color(index)
    return Gosu::Color::YELLOW if collisioned?

    if index.zero?
      Gosu::Color::YELLOW
    else
      Gosu::Color::WHITE
    end
  end

  def pos_x(x = @x)
    x * TILE_SIZE
  end

  def pos_y(y = @y)
    y * TILE_SIZE
  end

  def moving?
    @vel_x != 0 || @vel_y != 0
  end

  def selfbiting?
    tail[1..-1].include? [x, y]
  end

  def collisioned?
    !(0..WIDTH).include?(x) || !(0..HEIGHT).include?(y)
  end

  def grow_up
    tail.push(tail[-1])
  end

  def move(id)
    case id
    when Gosu::KB_LEFT
      unless @vel_x == 1
        @vel_x = -1
        @vel_y = 0
      end
    when Gosu::KB_RIGHT
      unless @vel_x == -1
        @vel_x = 1
        @vel_y = 0
      end
    when Gosu::KB_UP
      unless @vel_y == 1
        @vel_x = 0
        @vel_y = -1
      end
    when Gosu::KB_DOWN
      unless @vel_y == -1
        @vel_x = 0
        @vel_y = 1
      end
    end
  end
end
