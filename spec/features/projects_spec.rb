require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  include LoginSupport
  let(:user) { FactoryBot.create(:user) }

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    sign_in user
    visit root_path

    expect {
      create_project("Test Project", "Trying out Capybara")
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect_complete_project("Test Project", user.name)
    end
  end

  # ユーザーはプロジェクトを変更する
  scenario "user update the project" do
    sign_in user
    visit root_path

    create_project("Test Project", "Trying out Capybara")

    aggregate_failures do
      expect_complete_project("Test Project", user.name)
    end

    click_link "Edit"

    fill_in "Name", with: "Test Project2"
    fill_in "Description", with: "Trying out Capybara2"
    click_button "Update Project"

    expect(page).to have_content "Project was successfully updated."
  end

  def create_project(name, description)
    click_link "New Project"
    fill_in "Name", with: name
    fill_in "Description", with: description
    click_button "Create Project"
  end

  def expect_complete_project(name, owner)
    expect(page).to have_content "Project was successfully created"
    expect(page).to have_content name
    expect(page).to have_content "Owner: #{owner}"
  end
end
