Feature: Project management

Scenario Outline: display links
  Given Admin signed in
  When I visit the Admin Project index page
  Then I should see the <link>

  Examples:
  | New Project       |

Scenario: Should be able to view all projects
Given projects created
Given Admin signed in
When I visit the projects index page
Then I should see all projects

Scenario: Should be able to view project details
Given projects created
Given Admin signed in
When I visit the projects show page
Then I should see all details of a project

@javascript
Scenario: Should be able to create a new Project
Given a Manger already created
Given Admin signed in
Given I am on the New Project page
And I fill in "project_name" with "PMG"
And I fill in "project_client_name" with "Esteban"
And I select manager
When I press "Create Project"
Then I should see project "PMG" in index page

Scenario: Should be able to delete a project
Given projects created
Given Admin signed in
When I visit the projects index page
When I clicked on "Delete" link within "table"
And I confirm popup
Then I should not see deleted project
