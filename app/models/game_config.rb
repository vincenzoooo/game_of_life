class GameConfig
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :attachment, :generation, :current_generation, :width, :height, :initial_citizens, :can_start
  validates :attachment, presence: true

  # Define if the game can start
  def can_start
    @can_start || false
  end

  def startup
    # Read the configuration file
    tmp_data = File.readlines(attachment)
    # First check for the file, number of rows
    if tmp_data.size > 3
      # Get the generation number from the first row and remove it from the reading
      @generation = tmp_data.shift.split[1].to_i
      # Get the second row with height and width
      tmp_limits = tmp_data.shift.split
      @height, @width = tmp_limits[0].to_i, tmp_limits[1].to_i
      # All remaining rows represents the matrix
      @initial_citizens = []
      tmp_data.each { |row|
        # Split the strings in array
        @initial_citizens.push(row.chomp.split(//))
      }
      self.validate_instance
    else
      errors.add(:attachment, "Wrong file format")
    end
  end

  # Validate general format data of the file
  def validate_instance
    if initial_citizens.size == 0 || initial_citizens.size != height || initial_citizens[0].size != width
      errors.add(:attachment, "Wrong file format")
    else
      @can_start = true
    end
  end
end
