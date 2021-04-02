#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gosu'
require_relative 'fruit'
require_relative 'snake'

HEIGHT = 40
WIDTH = 40
TILE_SIZE = 10
STEPS_ALIVE = 1000

class SnakeGame < Gosu::Window
  attr_reader :snake, :fruit

  def initialize
    super WIDTH * TILE_SIZE + Menu::WIDTH, HEIGHT * TILE_SIZE + TILE_SIZE, false
    @snake = Snake.new
    @fruit = Fruit.new
    @menu = Menu.new(self)
    @font = Gosu::Font.new(self, Gosu.default_font_name, 20)
    @steps_alive = STEPS_ALIVE
    self.update_interval = 100
  end

  def button_down(id)
    case id
    when Gosu::KB_SPACE
      reset
    when Gosu::KB_ESCAPE
      exit
    else
      snake.move(id)
    end
  end

  def draw
    if eat_fruit?
      @fruit = Fruit.new
      @snake.grow_up
      @steps_alive = STEPS_ALIVE
    end

    if dead?
      gameover_text
    else
      @snake.step
      @steps_alive -= 1 if snake.moving?
    end

    @snake.draw
    @fruit.draw
    @menu.draw(@snake, @fruit, @steps_alive)
  end

  def dead?
    snake.selfbiting? || snake.collisioned? || starved?
  end

  def starved?
    @steps_alive <= 0
  end

  def eat_fruit?
    @fruit.x == @snake.x &&
      @fruit.y == @snake.y
  end

  def gameover_text
    draw_text('Game Over!', WIDTH / 2 * TILE_SIZE, HEIGHT / 2 * TILE_SIZE)
    draw_text('Press SPACE to CONTINUE', -60 + WIDTH / 2 * TILE_SIZE, 40 + HEIGHT / 2 * TILE_SIZE)
    draw_text('Press ESC to EXIT', -20 + WIDTH / 2 * TILE_SIZE, 80 + HEIGHT / 2 * TILE_SIZE)
  end

  def draw_text(text, x_pos, y_pos)
    @font.draw(text, x_pos, y_pos, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def reset
    @snake = Snake.new
    @fruit = Fruit.new
  end
end

class Menu
  WIDTH = 200
  X_OFFSET = 3 * TILE_SIZE

  def initialize(window)
    @font = Gosu::Font.new(window, Gosu.default_font_name, 20)
  end

  def draw(snake, fruit, steps_alive)
    Gosu.draw_rect(starting_x_pos + TILE_SIZE, 0, TILE_SIZE, HEIGHT * TILE_SIZE, Gosu::Color::GRAY)

    draw_text('Sneaky Snake-rb', starting_x_pos + X_OFFSET, 20)
    draw_text('Snake:', starting_x_pos + X_OFFSET, 60)
    draw_text("  Size: #{snake.tail.size}", starting_x_pos + X_OFFSET, 80)
    draw_text("  Pos: #{snake.x},#{snake.y}", starting_x_pos + X_OFFSET, 100)
    draw_text('Fruit:', starting_x_pos + X_OFFSET, 120)
    draw_text("  Pos: #{fruit.x},#{fruit.y}", starting_x_pos + X_OFFSET, 140)
    draw_text("Steps Alive: #{steps_alive}", starting_x_pos + X_OFFSET, 160)
  end

  def draw_text(text, x_pos, y_pos)
    @font.draw(text, x_pos, y_pos, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def starting_x_pos
    ::WIDTH * TILE_SIZE
  end
end

SnakeGame.new.show
