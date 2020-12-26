require 'gosu'

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
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @steps_alive = STEPS_ALIVE
    self.update_interval = 100
  end

  def button_down(id)
    if id == Gosu::KB_SPACE
      reset
    elsif id == Gosu::KB_ESCAPE
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

    if snake.selfbiting? || snake.collisioned? || starved?
      gameover_text
    else
      @snake.step
      @steps_alive -= 1 if snake.moving?
    end

    @snake.draw
    @fruit.draw
    @menu.draw(@snake, @fruit, @steps_alive)

  end

  def starved?
    @steps_alive <= 0
  end

  def eat_fruit?
    @fruit.x == @snake.x &&
      @fruit.y == @snake.y
  end

  def gameover_text
    draw_text("Game Over!", WIDTH / 2 * TILE_SIZE, HEIGHT / 2 * TILE_SIZE)
    draw_text("Press SPACE to CONTINUE", -60 + WIDTH / 2 * TILE_SIZE, 40 + HEIGHT / 2 * TILE_SIZE)
  end

  def gameover_text
    draw_text("Game Over!", WIDTH / 2 * TILE_SIZE, HEIGHT / 2 * TILE_SIZE)
    draw_text("Press SPACE to CONTINUE", -60 + WIDTH / 2 * TILE_SIZE, 40 + HEIGHT / 2 * TILE_SIZE)
  end

  def draw_text(text, x, y)
    @font.draw(text, x, y, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def reset
    @snake = Snake.new
    @fruit = Fruit.new
  end
end

class Snake
  attr_reader :x, :y, :tail, :size
  MIN_SIZE = 3

  def initialize
    @x = rand(0..WIDTH)
    @y = rand(0..HEIGHT)

    @size = MIN_SIZE

    @tail = []

    size.times do |i|
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
    if @vel_x != 0 or @vel_y != 0
      tail.insert 0, [@x, @y]
      tail.pop
    end
  end

  def draw
    tail.each_with_index do |elem, index|
      x, y = elem
      if index == 0
        Gosu.draw_rect(pos_x(x), pos_y(y), TILE_SIZE, TILE_SIZE, color(index))
      else
        Gosu.draw_rect(pos_x(x), pos_y(y), TILE_SIZE, TILE_SIZE, color(index))
      end
    end
  end

  def color(index)
    return Gosu::Color::YELLOW if collisioned?

    if index == 0
      Gosu::Color::YELLOW
    else
      Gosu::Color::WHITE
    end
  end

  def pos_x(x = @x)
    x *TILE_SIZE
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
    @size += 1
    tail.push(tail[-1])
  end

  def move(id)
    case id
    when Gosu::KB_LEFT
      @vel_x, @vel_y = -1, 0 unless @vel_x == 1
    when Gosu::KB_RIGHT
      @vel_x, @vel_y = 1, 0 unless @vel_x == -1
    when Gosu::KB_UP
      @vel_x, @vel_y = 0, -1 unless @vel_y == 1
    when Gosu::KB_DOWN
      @vel_x, @vel_y = 0, 1 unless @vel_y == -1
    end
  end
end

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

class Menu
  WIDTH = 200
  X_OFFSET = 3 * TILE_SIZE

  def initialize(window)
    @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
  end

  def draw(snake, fruit, steps_alive)
    Gosu.draw_rect(starting_x_pos + TILE_SIZE, 0, TILE_SIZE, HEIGHT * TILE_SIZE, Gosu::Color::GRAY)
    y_pos = 0

    draw_text("Sneaky Snake-rb", starting_x_pos + X_OFFSET, 20)
    draw_text("Snake:", starting_x_pos + X_OFFSET, 60)
    draw_text("  Size: #{snake.tail.size}", starting_x_pos + X_OFFSET, 80)
    draw_text("  Pos: #{snake.x},#{snake.y}", starting_x_pos + X_OFFSET, 100)
    draw_text("Fruit:", starting_x_pos + X_OFFSET, 120)
    draw_text("  Pos: #{fruit.x},#{fruit.y}", starting_x_pos + X_OFFSET, 140)
    draw_text("Steps Alive: #{steps_alive}", starting_x_pos + X_OFFSET, 160)
  end

  def draw_text(text, x, y)
    @font.draw(text, x, y, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def starting_x_pos
    ::WIDTH * TILE_SIZE
  end
end

SnakeGame.new.show
