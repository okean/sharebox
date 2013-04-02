FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test.user@sharebox.com"
    password "foobar"
    password_confirmation "foobar"
  end
  
  factory :data_file do
    user
    uploaded_file { fixture_file_upload("#{Rails.root}/spec/fixtures/images/test.jpg", 'image/jpg') }
  end
  
  factory :folder do
    user 
    name "test_folder"
  end
  
  sequence :file_name do |n|
    fixture_file_upload("#{Rails.root}/spec/fixtures/images/test#{n}.jpg", 'image/jpg')
  end
end