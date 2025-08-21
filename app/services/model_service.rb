class ModelService
  def self.run!(record)
    new(record).result
  end

  def self.run(record)
    new(record)
  end

  def result
    # do nothing
  end
end