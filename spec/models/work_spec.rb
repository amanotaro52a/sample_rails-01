require 'rails_helper'

RSpec.describe Work, type: :model do
  describe 'バリデーション' do
    context '失敗パターン' do
      it 'titleがない場合、invalidになる' do
        work = build(:work, title: nil)
        expect(work).to be_invalid
      end

      it 'bodyがない場合、invalidになる' do
        work = build(:work, body: nil)
        expect(work).to be_invalid
      end

      it 'titleが255文字を超える場合、invalidになる' do
        work = build(:work, title: 'a' * 256)
        expect(work).to be_invalid
      end

      it 'bodyが65,535文字を超える場合、invalidになる' do
        work = build(:work, body: 'a' * 65_536)
        expect(work).to be_invalid
      end
    end

    context '成功パターン' do
      it 'titleとbodyが適切に設定されていればvalidになる' do
        work = build(:work)
        expect(work).to be_valid
      end
    end
  end
end
