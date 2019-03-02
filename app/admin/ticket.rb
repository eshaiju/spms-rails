# frozen_string_literal: true

ActiveAdmin.register Ticket do
  menu priority: 3

  permit_params :title, :description, :project_id, :category, :status, :maximum_permitted_time, :start_date, :end_date, :assigned_user_id, :created_user_id, :created_user_type

  filter :title
  filter :start_date
  filter :category,
         as: :select,
         collection: Ticket.categories.invert,
         input_html: { class: 'chosen-input' }
  filter :status,
         as: :select,
         collection: Ticket.states.invert,
         input_html: { class: 'chosen-input' }
  filter :project,
         as: :select,
         collection: Project.all,
         input_html: { class: 'chosen-input' }

  index do
    selectable_column
    id_column
    column :title
    column :project
    column :category
    column :status
    column :assigned_user
    actions
  end

  show do |_project|
    columns do
      column do
        attributes_table do
          row :id
          row :title
          row :description
          row :project
          row :maximum_permitted_time
          row :start_date
          row :edn_date
          row :status
          row :category
          row :assigned_user
          row :created_user
        end
      end
      column do
        panel 'Activities' do
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :project,
              as: :select,
              collection: Project.all,
              input_html: { class: 'chosen-input' }
      f.input :category,
              as: :select,
              collection: Ticket.categories.invert,
              input_html: { class: 'chosen-input' }
      f.input :status,
              as: :select,
              collection: Ticket.states.invert,
              input_html: { class: 'chosen-input' }
      f.input :maximum_permitted_time
      f.input :start_date,
              as: :datepicker,
              input_html: { readonly: 'readonly' }
      f.input :end_date,
              as: :datepicker,
              input_html: { readonly: 'readonly' }
      f.input :assigned_user,
              as: :select,
              collection: User.all,
              input_html: { class: 'chosen-input' }
      f.hidden_field :created_user_id, value: current_admin_user.id
      f.hidden_field :created_user_type, value: 'AdminUser'
    end
    f.actions
  end

  controller do
    def scoped_collection
      Ticket.includes(:project, :assigned_user)
    end
  end
end