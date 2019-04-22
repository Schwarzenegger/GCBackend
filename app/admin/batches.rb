ActiveAdmin.register Batch do
  menu priority: 2

  actions  :index, :show

  filter :reference
  filter :created_at

end
