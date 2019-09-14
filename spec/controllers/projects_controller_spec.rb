require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      # 200レスポンスを返すこと
      it "return a 200 responds" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      # サインイン画面へ遷移すること
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#new" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.build(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :new
        expect(response).to be_success
      end

      # 200レスポンスを返すこと
      it "return a 200 responds" do
        sign_in @user
        get :new
        expect(response).to have_http_status "200"
      end
    end

    # ゲストとして
    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get :new
        expect(response).to have_http_status "302"
      end

      # サインイン画面へ遷移すること
      it "redirects to the dashboard" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :show, params: {id: @project}
        expect(response).to be_success
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: {id: @project}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#edit" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :edit, params: {id: @project}
        expect(response).to be_success
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        get :edit, params: {id: @project}
        expect(response).to redirect_to root_path
      end
    end
  end


  describe "#create" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      # 有効な属性値として
      context "with valid attributes" do
        # プロジェクトを追加できること
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect {
            post :create, params: {project: project_params}
          }.to change(@user.projects, :count).by(1)
        end
      end

      # 無効な属性値として
      context "with invalid attributes" do
        it "does not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post :create, params: {project: project_params}
          }.to_not change(@user.projects, :count)
        end
      end
    end

    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: {project: project_params}
        expect(response).to have_http_status "302"
      end

      # サインイン画面へ遷移すること
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: {project: project_params}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを更新できること
      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: "New Project Name")
        sign_in @user
        patch :update, params: {id: @project, project: project_params}
        expect(@project.reload.name).to eq "New Project Name"
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project,
                                     owner: other_user,
                                     name: "Same Old Name"
        )
      end

      # プロジェクトを更新できないこと
      it "does not update the project" do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: "New Name")
        sign_in @user
        patch :update, params: {id: @project, project: project_params}
        expect(@project.reload.name).to eq "Same Old Name"
      end

      # ダッシュボードへ理解すること
      it "redirects to the dashboard" do
        project_params = FactoryBot.attributes_for(:project,
                                                   name: "New Name")
        sign_in @user
        patch :update, params: {id: @project, project: project_params}
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    context "as an guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: {id: @project, project: project_params}
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign_in page" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: {id: @project, project: project_params}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを削除できること
      it "deletes a project" do
        sign_in @user
        expect {
          delete :destroy, params: {id: @project}
        }.to change(@user.projects, :count).by(-1)
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        sign_in @user
        expect {
          delete :destroy, params: {id: @project}
        }.to_not change(@user.projects, :count)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        delete :destroy, params: {id: @project}
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    context "as an guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      # 302レスポンスを返すこと
      it "returns an 302 response" do
        delete :destroy, params: {id: @project}
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign_in page" do
        delete :destroy, params: {id: @project}
        expect(response).to redirect_to "/users/sign_in"
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        expect {
          delete :destroy, params: {id: @project}
        }.to_not change(Project, :count)
      end
    end
  end
end