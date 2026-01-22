require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常な場合' do
      it 'ログイン処理が成功する', js: true do
        visit new_user_session_path

        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'

        expect(page).to have_current_path(root_path)

        find('#header-profile').click
        expect(page).to have_link('ログアウト')
      end
    end

    context 'フォームの値が未入力の場合' do
      it 'ログインに失敗する', js: true do
        visit new_user_session_path

        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_button('ログイン')
        expect(page).not_to have_link('ログアウト')
      end
    end
  end

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    it 'ログアウトされる', js: true do
      find('#header-profile').click
      click_link 'ログアウト'

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_link('ログイン')
      expect(page).not_to have_link('ログアウト')
    end
  end
end
