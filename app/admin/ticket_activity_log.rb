# frozen_string_literal: true

ActiveAdmin.register TicketActivityLog do
  menu priority: 4

  permit_params :activity, :log_time, :log_date, :status, :approved_by_id, :ticket_id, :user_id

  filter :activity
  filter :log_date
  filter :user,
         as: :select,
         collection: User.all,
         input_html: { class: 'chosen-input' }
  filter :ticket,
         as: :select,
         collection: Ticket.all,
         input_html: { class: 'chosen-input' }

  index do
    selectable_column
    id_column
    column :activity
    column :log_time
    column :log_date
    column :ticket_no
    column :user
    column :status
    actions
  end

  show do |_project|
    columns do
      column do
        attributes_table do
          row :id
          row :activity
          row :log_time
          row :log_date
          row :ticket
          row :user
          row :start_date
          row :status
          row :approved_by
          row :created_at
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :activity
      f.input :log_time
      f.input :log_date,
              as: :datepicker,
              input_html: { readonly: 'readonly' }
      f.input :ticket,
              as: :select,
              collection: Ticket.all,
              input_html: { class: 'chosen-input' }
      f.input :user,
              as: :select,
              collection: User.all,
              input_html: { class: 'chosen-input' }
      f.input :status
    end
    f.actions
  end

  controller do
    def scoped_collection
      TicketActivityLog.includes(:ticket, :user)
    end
  end
end
