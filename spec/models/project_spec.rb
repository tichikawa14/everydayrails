require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    @user.projects.create(
      name: "Test Project",
    )
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    new_project = @user.projects.build(
      name: "Test Project",
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    other_user = User.create(
      first_name: "ichi",
      last_name: "tatsu",
      email: "ichi@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end

  # プロジェクト名が空の場合、プロジェクトが作られないこと
  it "プロジェクト名が空の場合、プロジェクトが作られないこと" do

    other_project = @user.projects.new(
      name: nil,
    )
    other_project.valid?
    expect(other_project.errors[:name]).to include("can't be blank")
  end
end
