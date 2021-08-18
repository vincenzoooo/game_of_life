class GameBoard
  include ActiveModel::Model

  attr_accessor :configuration, :citizens

  def initialize(configuration)
    @configuration = configuration
    @citizens = []
    configuration.height.times do |x|
      @citizens.push([])
      configuration.width.times do |y|
        @citizens[x].push(Citizen.new(self, x, y))
      end
    end
  end

  # Simplify the structure of the citizens
  def plane_citizens
    @citizens.flatten
  end

  # Get a specific citizen in the matrix
  # after check the index existence
  def citizen_at(x, y)
    if x >= 0 && x < @citizens.size
      if y >= 0 && y < @citizens[x].size
        @citizens[x][y]
      end
    end
  end

  # Define the calculation of the next generation
  def next_generation!
    affected = []
    plane_citizens.each do |citizen|
      if self.must_change_citizen_status(citizen)
        affected.push citizen
      end
    end
    affected.each(&:change!)
    # Get next generation number
    configuration.generation += 1
    return
  end

  private
  # Check if citizen status must change
  def must_change_citizen_status(citizen)
    citizen.is_alive? && (citizen.live_neighbours.length < 2 || citizen.live_neighbours.length > 3) || citizen.is_dead? && (citizen.live_neighbours.length == 3)
  end

end
