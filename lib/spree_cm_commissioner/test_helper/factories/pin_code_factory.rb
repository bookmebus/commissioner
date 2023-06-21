FactoryBot.define do
  factory :pin_code, class: SpreeCmCommissioner::PinCode do
    code { '' }
    type { 'MyStore::PinCodeLogin' }
    contact { '087420441' }
    contact_type { :phone_number }
    expires_in { 180 }
    expired_at { '' }
    number_of_attempt { 0 }
    token { '' }
    
    trait :with_email do
      contact_type { :email }
      sequence(:contact) { |n| "user-#{n}@gmail.com" }
    end
    
    trait :with_number do
      contact_type { :phone_number }
      sequence(:contact) { |_n| "087420441#{N}" }
    end
  end
end