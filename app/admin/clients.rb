ActiveAdmin.register Client do
  menu priority: 4

  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    actions
  end

  filter :name
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
    end
    f.actions
  end

end
