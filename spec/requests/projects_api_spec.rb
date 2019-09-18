require 'rails_helper'

RSpec.describe "ProjectsApi", type: :request do
  describe "GET /projects_api" do
    # 1件のプロジェクトを読み出すこと
    it "loads a project" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project,
                        name: "Sample Project")
      FactoryBot.create(:project,
                        name: "Second Simple Project",
                        owner: user)

      get api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      project_id = json[0]["id"]

      get api_project_path(project_id), params: {
        user_email: user.email,
        user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "Second Simple Project"
    end
  end

  # プロジェクトを作成できること
  it "create a project" do
    user = FactoryBot.create(:user)
    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end
end
