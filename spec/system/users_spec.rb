require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常な場合' do
        it 'ユーザー登録に成功し、投稿一覧へ遷移する' do
          visit new_user_registration_path

          fill_in '名前', with: '新規ユーザー'
          fill_in 'メールアドレス', with: 'new_user@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認用）', with: 'password'

          find('input[type="submit"]').click

          expect(current_path).to eq posts_path
          expect(User.last.name).to eq '新規ユーザー'
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'ユーザー登録に失敗する' do
          visit new_user_registration_path

          fill_in '名前', with: 'テストユーザー'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認用）', with: 'password'

          find('input[type="submit"]').click

          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq user_registration_path
        end
      end

      context '登録済みのメールアドレスを入力した場合' do
        let!(:user) { create(:user) } # test@example.com

        it 'ユーザー登録に失敗する' do
          visit new_user_registration_path

          fill_in '名前', with: '別ユーザー'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認用）', with: 'password'

          find('input[type="submit"]').click

          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq user_registration_path
        end
      end
    end

    describe 'アクセス制御' do
      context '自分以外のユーザー編集ページに遷移した場合' do
        let!(:user) { create(:user) }

        it 'ログインページへリダイレクトされる' do
          visit edit_user_registration_path

          expect(current_path).to eq new_user_session_path
          expect(page).to have_content 'ログイン'
        end
      end
    end
  end
end
