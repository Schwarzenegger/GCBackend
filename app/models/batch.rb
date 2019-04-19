class Batch < ApplicationRecord
  has_many :orders

  before_create :set_reference

  private
  def set_reference
    loop do
      r = "#{Date.today.to_s.delete("-")}-#{DateTime.now.to_i}"
      unless Batch.exists?(reference: r)
        break self.reference = r
      end
    end

  end
end
