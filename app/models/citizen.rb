class Citizen
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :alive, :neighbours, :game, :row, :column

  def initialize(game, row, column)
    @game, @row, @column = game, row, column
    # For configuration of the game a citizen is alive if is equal *
    @alive = game.configuration.initial_citizens[row][column] == '*'
  end

  def neighbours
    @neighbours = []
    # Define previous row neighbours
    @neighbours.push(@game.citizen_at(self.row - 1, self.column - 1))
    @neighbours.push(@game.citizen_at(self.row - 1, self.column))
    @neighbours.push(@game.citizen_at(self.row - 1, self.column + 1))

    # Define same row neighbours
    @neighbours.push(@game.citizen_at(self.row, self.column - 1))
    @neighbours.push(@game.citizen_at(self.row, self.column + 1))

    # Define next row neighbours
    @neighbours.push(@game.citizen_at(self.row + 1, self.column - 1))
    @neighbours.push(@game.citizen_at(self.row + 1, self.column))
    @neighbours.push(@game.citizen_at(self.row + 1, self.column + 1))
  end

  def is_alive?
    @alive
  end

  def is_dead?
    !@alive
  end

  # Change the alive status of a citizen
  def change!
    @alive = !@alive
  end

  # Get actual live neighbours of the citizen
  def live_neighbours
    self.neighbours.select do |n|
      n && n.is_alive?
    end
  end
end
