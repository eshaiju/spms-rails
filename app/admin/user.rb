ActiveAdmin.register User do
  menu priority: 3
  permit_params :first_name, :last_name, :email, :emp_id, :designation, :password, :password_confirmation

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
  filter :designation, as: :select, collection: proc { User.designations.invert }

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :emp_id, label: 'Employ ID'
      f.input :designation, as: :select, collection: User.designations.invert
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      model = :user
      if params[model][:password].blank?
        %w(password password_confirmation).each { |p| params[model].delete(p) }
      end
      super
    end
  end
end
