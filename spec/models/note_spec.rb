require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is an example",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do
    let(:note1) {
      FactoryBot.create(:note,
                        project: project,
                        user: user,
                        message: "This is the first note.",
      )
    }

    let(:note2) {
      FactoryBot.create(:note,
                        message: "This is the second note.",
                        user: user,
      )
    }

    let(:note3) {
      FactoryBot.create(:note,
                        message: "First, preheat the oven.",
                        user: user,
      )
    }

    # 一致するデータが見つかる時
    context "when a match is found" do
      it "検索文字列に一致するメモを返すこと" do
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    # 一致するデータが1件も見つからないとき
    context "when no match is found" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
