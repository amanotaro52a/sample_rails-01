FactoryBot.define do
  factory :work do
    title { 'タイトル' }
    body  { '本文です' }
    association :user
  end
end
