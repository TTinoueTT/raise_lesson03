require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } # ユーザーAを定義
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } # ユーザーBを定義
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) } # 作成者がユーザーAであるタスクを定義

  before do
    visit login_path # ログイン画面へのアクセス(Capybaraを利用)
    fill_in 'session_email', with: login_user.email # テキストフィードバックに値を入れる
    fill_in 'session_password', with: login_user.password
    click_button 'session_submit'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }
      it_behaves_like 'ユーザーAが作成したタスクが表示される' # 作成済みのタスクの名称が画面上に表示されていることを確認
    end

    context 'ユーザーBがログインしている時' do
      let(:login_user) { user_b }
      it 'ユーザーAが作成したタスクが表示されない' do
        expect(page).to have_no_content '最初のタスク'
        # ユーザーAが作成したタスクの名称が画面上に表示されないことを確認
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in 'task_name', with: task_name
      click_button 'submit'
    end

    context '新規作成画面で名称を入力した時' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかった時' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content "Name can't be blank"
        end
      end
    end
  end
end
