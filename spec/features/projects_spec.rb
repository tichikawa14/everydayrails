require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  before do
    @user = FactoryBot.create(:user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Log in"
  end

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{@user.name}"
    }.to change(@user.projects, :count).by(1)
  end

  # ユーザーはプロジェクトを変更する
  scenario "user creates a new project" do

      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{@user.name}"

      click_link "Edit"

      fill_in "Name", with: "Test Project2"
      fill_in "Description", with: "Trying out Capybara2"
      click_button "Update Project"

      expect(page).to have_content "Project was successfully updated."

  end
end
