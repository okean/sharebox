# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shared_folder do
    user_id 1
    shared_email "MyString"
    shared_user_id 1
    folder ""
    message "MyString"
  end
end
