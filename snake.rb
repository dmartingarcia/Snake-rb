#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gosu'

class Snake
  attr_reader :vel_x, :vel_y, :x, :y, :tail

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

    return unless moving?

    tail.insert 0, [@x, @y]
    tail.pop
  end

  def size
    tail.size
  end

  def draw
    tail.each_with_index do |elem, index|
      x, y = elem
      Gosu.draw_rect(pos_x(x), pos_y(y), TILE_SIZE, TILE_SIZE, color(index))
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

  def pos_x(x_tile = @x)
    x_tile * TILE_SIZE
  end

  def pos_y(y_tile = @y)
    y_tile * TILE_SIZE
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

  def move(key_id)
    case key_id
    when Gosu::KB_LEFT
      return if @vel_x == 1

      @vel_x = -1
      @vel_y = 0
    when Gosu::KB_RIGHT
      return if @vel_x == -1

      @vel_x = 1
      @vel_y = 0
    when Gosu::KB_UP
      return if @vel_y == 1

      @vel_x = 0
      @vel_y = -1
    when Gosu::KB_DOWN
      return if @vel_y == -1

      @vel_x = 0
      @vel_y = 1
    end
  end
end
