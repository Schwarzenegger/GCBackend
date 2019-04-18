class Order < ApplicationRecord
  belongs_to :client
  belongs_to :purchase_channel

  before_create :set_reference
  serialize :line_items, Array

  validates :delivery_address, presence: true
  validates :delivery_service, presence: true
  validates :total_value, presence: true

  scope :by_purchase_channel, -> (id=nil) { where(purchase_channel: id) unless id.nil? }
  scope :by_status, -> (status=nil) { where(status: status) unless status.nil? }

  def line_items_raw
    self.line_items.join("\n") unless self.line_items.nil?
  end

  def line_items_raw=(values)
    self.line_items = []
    self.line_items=values.split(",")
  end

  enum delivery_service:
      { pac: 1,
      sedex: 2,
    courier: 3 }

  enum status:
      { ready: 1,
   production: 2,
      closing: 3,
         sent: 4 } do


    event :start_production do
      before do
        self.when_entered_production = DateTime.now
      end

      transition :ready => :production
    end

    event :finish_product do
      before do
        self.finished_production = DateTime.now
      end

      transition :production => :closing
    end

    event :deliver do
      before do
        self.send_date = DateTime.now
      end

      transition :closing => :sent
    end
  end

  private

  def set_reference
    loop do
      r = "#{self.purchase_channel.id}/#{self.purchase_channel.name.split.map(&:first).join}-#{DateTime.now.to_i}"
      unless Order.exists?(reference: r)
        break self.reference = r
      end
    end
  end

end
