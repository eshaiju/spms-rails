# frozen_string_literal: true

Given('projects created') do
  create_projects
end

When('I visit the projects index page') do
  visit admin_projects_path
end

Then('I should see all projects') do
  Project.all.map do |project|
    expect_contents project_summary(project)
  end
end

Given('a manager already created') do
  create_user
end

Given('I am on the New Project page') do
  visit new_admin_project_path
end

Given('I fill in {string} with {string}') do |string, string2|
  fill_in string, with: string2
end

Given('I select manager') do
  select_from_chosen(manager_name, from: 'project_manager_id')
end

When('I press {string}') do |string|
  find_button(string).click
end

Then('I should see project {string} in index page') do |string|
  project = project_from_name(string)
  expect_contents project_summary(project)
end

When('I visit the projects show page') do
  visit admin_project_path(first_project)
end

Then('I should see all details of a project') do
  expect_contents project_details(first_project)
end

When('I clicked on {string} link within {string}') do |link, container|
  within(container) do
    click_link(link, match: :first)
  end
end

When('I clicked on {string}') do |link|
  click_link(link, match: :first)
end

When('I confirm popup') do
  true
end

Then('I should not see deleted project') do
  expect(Project.count).to eq 1
end
