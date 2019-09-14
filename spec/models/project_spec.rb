require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: "Test Project", owner: @user)
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    new_project = FactoryBot.build(:project, name: "Test Project", owner: @user)
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    other_user = FactoryBot.create(:user,
                      first_name: "ichi",
                      last_name: "tatsu")

    # other_user = User.create(
    #   first_name: "ichi",
    #   last_name: "tatsu",
    #   email: "ichi@example.com",
    #   password: "dottle-nouveau-pavilion-tights-furze",
    # )
    other_project = FactoryBot.build(:project, name: "Test Project", owner: other_user)
    #
    # other_project = other_user.projects.build(
    #   name: "Test Project",
    # )
    expect(other_project).to be_valid
  end

  # プロジェクト名が空の場合、プロジェクトが作られないこと
  it "プロジェクト名が空の場合、プロジェクトが作られないこと" do

    other_project = FactoryBot.build(:project, name: nil, owner: @user)
    # other_project = @user.projects.new(
    #   name: nil,
    # )
    other_project.valid?
    expect(other_project.errors[:name]).to include("can't be blank")
  end

  # たくさんのメモが付いていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日なら予定どおりであること
    it "is ont time when the due date is today" do
      project = FactoryBot.create(:project_due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来なら予定どおりであること
    it "is ont time when the due date is tomorros" do
      project = FactoryBot.create(:project_due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
