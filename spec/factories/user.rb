FactoryBot.define do
  factory :user do
    nickname              { 'テストユーザ' }
    email                 { Faker::Internet.email }
    password              { 'password' }
    password_confirmation { 'password' }
  end
end