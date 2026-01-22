require 'rails_helper'

RSpec.describe 'Works', type: :system do
  let(:user) { create(:user) }
  let(:work) { create(:work, user: user) }

  describe 'ログイン前' do
    it '新規作成ページにアクセスできない' do
      visit new_work_path
      expect(current_path).to eq new_user_session_path
    end

    it '編集ページにアクセスできない' do
      visit edit_work_path(work)
      expect(current_path).to eq new_user_session_path
    end

    it '作品一覧ページにアクセスできない' do
      visit works_path
      expect(current_path).to eq new_user_session_path
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user)
    end

    describe 'work新規作成' do
      before do
        visit new_work_path
      end

      it 'タイトル未入力 → 登録失敗' do
        fill_in 'work_title', with: ''
        fill_in 'work_body', with: '本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_not_created')
      end

      it 'フォーム未入力 → 登録失敗' do
        fill_in 'work_title', with: ''
        fill_in 'work_body', with: ''
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_not_created')
      end

      it 'タイトルの入力値が正常 → 登録成功' do
        fill_in 'work_title', with: '正常タイトル'
        fill_in 'work_body', with: '本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_created')
        expect(current_path).to eq works_path
      end

      it 'フォームの入力値が正常 → 登録成功' do
        fill_in 'work_title', with: 'タイトル'
        fill_in 'work_body', with: '正常本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_created')
      end
    end

    describe 'workの編集' do
      before do
        visit edit_work_path(work)
      end

      it 'タイトル未入力 → 登録失敗' do
        fill_in 'work_title', with: ''
        fill_in 'work_body', with: '更新本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_not_update')
      end

      it 'フォーム未入力 → 登録失敗' do
        fill_in 'work_title', with: ''
        fill_in 'work_body', with: ''
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_not_update')
      end

      it 'タイトルの入力値が正常 → 登録成功' do
        fill_in 'work_title', with: '更新後タイトル'
        fill_in 'work_body', with: '更新本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_update')
        expect(current_path).to eq work_path(work)
      end

      it 'フォームの入力値が正常 → 登録成功' do
        fill_in 'work_title', with: '正常更新'
        fill_in 'work_body', with: '正常本文'
        click_button type: 'submit'

        expect(page).to have_content I18n.t('defaults.flash_message.work_update')
      end
    end

    describe 'workの削除' do
      it 'workを削除できる' do
        visit work_path(work)

        find("#button-delete-#{work.id}").click

        expect(page).to have_content I18n.t('defaults.flash_message.work_destroy')
        expect(Work.exists?(work.id)).to be false
      end
    end
  end
end
