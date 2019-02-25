# frozen_string_literal: true

ActiveAdmin.register Project do
  menu priority: 2

  permit_params :name, :client_name, :start_date, :manager_id, user_ids: []

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
  filter :manager, as: :select, collection: User.all, input_html: { class: 'chosen-input' }

  show do |_project|
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row :client_name
          row :manager
          row :created_at
        end
      end
      column do
        panel 'Assigned Users' do
          table_for resource.users do
            column 'User Name' do |user|
              link_to user.name, admin_user_path(user)
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :client_name
      f.input :manager, as: :select, collection: User.all, input_html: { class: 'chosen-input' }
      f.input :users, as: :select, collection: User.all, input_html: { class: 'chosen-input' }
    end
    f.actions
  end
end
