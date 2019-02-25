# frozen_string_literal: true

Given(/^Admin signed in$/) do
  create_admin_user
  sign_admin_user_in
end
