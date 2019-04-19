ActiveAdmin.register Batch do
  actions  :index, :show

  filter :reference
  filter :created_at

end
