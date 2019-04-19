class BatchSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :reference

  has_many :orders
end
