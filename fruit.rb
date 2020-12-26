#!/usr/bin/env ruby

require 'gosu'

class Fruit
  attr_reader :x, :y

  def initialize
    @x = rand(0.. WIDTH)
    @y = rand(0..HEIGHT)
  end

  def pos_x
    @x * TILE_SIZE
  end

  def pos_y
    @y * TILE_SIZE
  end

  def draw
    Gosu.draw_rect(pos_x, pos_y, TILE_SIZE, TILE_SIZE, Gosu::Color::RED)
  end
end
