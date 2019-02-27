# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 3
  permit_params :first_name, :last_name, :email, :emp_id, :designation,
                :password, :password_confirmation, project_ids: []

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :emp_id
    column :designation
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :designation,
         as: :select,
         collection: proc { User.designations.invert },
         input_html: { class: 'chosen-input' }

  show do |user|
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row :email
          row :current_sign_in_at
          row :sign_in_count
          row :created_at
          row 'Link for confirm' do |_cr|
            if user.confirmed? == false
              link_to 'Confirm',
                      add_member_admin_user_path,
                      data: { confirm: 'Are you sure?' },
                      class: 'btn-clear'
            else
              'Confirmed'
            end
          end
        end
      end
      column do
        panel 'Assigned Projects' do
          table_for resource.projects do
            column 'Project Name' do |project|
              link_to project.name, admin_project_path(project)
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :emp_id, label: 'Employ ID'
      f.input :designation,
              as: :select,
              collection: User.designations.invert,
              input_html: { class: 'chosen-input' }
      f.input :projects,
              as: :select,
              collection: Project.all,
              input_html: { class: 'chosen-input' }
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  member_action :add_member, method: :get do
    resource.confirm
    redirect_to admin_users_path(resource),
                notice: 'Successfully confirmed the user'
  end

  controller do
    def update
      model = :user
      if params[model][:password].blank?
        %w[password password_confirmation]
          .each { |p| params[model].delete(p) }
      end
      super
    end
  end
end
