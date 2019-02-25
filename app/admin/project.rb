# frozen_string_literal: true

ActiveAdmin.register Project do
  menu priority: 2

  permit_params :name, :client_name, :start_date, :manager_id

  index do
    selectable_column
    id_column
    column :name
    column :client_name
    column :manager
    actions
  end

  filter :name
  filter :client_name
  filter :manager

  show do |user|
    attributes_table do
      row :id
      row :name
      row :client_name
      row :manager
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :client_name
      f.input :manager, as: :select, collection: User.all
    end
    f.actions
  end
end
