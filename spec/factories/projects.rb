FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."
    due_on 1.week.from_now
    association :owner

    # メモ付きのプロジェクト
    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project)}
    end

    # 無効になっている
    trait :invalid do
      name nil
    end

    # 昨日が締め切りのプロジェクト
    factory :project_due_yesterday, class: Project do
      due_on 1.day.ago
    end

    # 今日が締め切りのプロジェクト
    factory :project_due_today, class: Project do
      due_on Date.current.in_time_zone
    end

    # 明日が締め切りのプロジェクト
    factory :project_due_tomorrow, class: Project do
      due_on 1.day.from_now
    end
  end
end
