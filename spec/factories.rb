FactoryGirl.define do
	factory :user do
		name			"Daniel Soskel"
		email			"dsoskel@memphis.edu"
		password	"foobar"
		password_confirmation "foobar"
	end
end