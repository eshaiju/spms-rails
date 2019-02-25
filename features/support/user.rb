# frozen_string_literal: true

def manager_name
  User.first.name
end

def create_user
  FactoryBot.create(:user,
                    password: user_password,
                    password_confirmation: user_password)
end

def user_password
  'f4k3p455w0rd'
end
