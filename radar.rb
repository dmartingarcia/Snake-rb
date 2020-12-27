#!/usr/bin/env ruby

class Radar
  def initialize(snake, fruit)
    @snake = snake
    @fruit = fruit
  end

  def front_fruit
    vector_distance(*vector_to_fruit) * snake_direction_vector.last
  end

  def left_fruit
    vector_distance(*vector_to_fruit) * snake_direction_vector.first
  end

  def right_fruit
    -left_fruit
  end

  def rear_fruit
    -front_fruit
  end

  def front_wall

  end

  def left_wall

  end

  def right_wall

  end

  def rear_wall

  end

  def vector_distance(x, y)
    Math.sqrt((x ** 2) +
              (y ** 2)).to_i
  end

  def vector_to_fruit
    @vector_to_fruit ||=
      [@fruit.x - @snake.x, @fruit.y - @snake.y]
  end

  def snake_direction_vector
    @snake_direction_vector ||=
      [@snake.vel_x, @snake.vel_y]
  end
end
