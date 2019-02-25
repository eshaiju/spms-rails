# frozen_string_literal: true

def create_projects
  2.times do
    FactoryBot.create(:project)
  end
end

def project_summary(project)
  %i[id name client_name]
    .map { |key| project.send(key) }
    .append(project.manager.name)
end

def project_details(project)
  %i[id name client_name]
    .map { |key| project.send(key) }
    .append(project.manager.name)
    .append(project.users.send(:name))
end

def project_from_name(name)
  Project.find_by(name: name)
end

def first_project
  Project.first
end
