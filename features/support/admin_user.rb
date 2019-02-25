# frozen_string_literal: true

def sign_admin_user_in
  visit admin_user_session_path

  fill_in :admin_user_email, with: AdminUser.first.email
  fill_in :admin_user_password, with: user_password

  find_button('Login').click
end

def create_admin_user
  FactoryBot.create(:admin_user,
                    password: user_password,
                    password_confirmation: user_password)
end

def user_password
  'f4k3p455w0rd'
end
