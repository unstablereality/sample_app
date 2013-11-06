require 'spec_helper'

describe "Authentication" do

	subject { page }
	
	describe "signin" do
		before { visit signin_path }
		
		describe "with invalid information" do
			before { click_button "Sign in" }
			
			it { should have_title('Sign in') }
			it { should have_error_message('Invalid') }
			
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message('Invalid') }
			end
		end
		
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }
			
			it { should have_title(user.name) }
			it { should have_link('Users', 			 href: users_path) }
			it { should have_link('Profile', 		 href: user_path(user)) }
			it { should have_link('Settings', 	 href: edit_user_path(user)) }
			it { should have_link('Sign out', 	 href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			
			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end
	
	describe "authorization" do
	
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
		
			describe "in the Users controller" do
				
				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end
				
        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end
			end
			
			describe "in the Microposts controller" do
				before { post microposts_path }
				specify { expect(response).to redirect_to(signin_path) }
			end
			
			describe "submitting to the destroy action" do
				before { delete micropost_path(FactoryGirl.create(:micropost)) }
				specify { expect(response).to redirect_to(signin_path) }
			end
			
			describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
			
		end
		
		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }
			
			before { sign_in non_admin, no_capybara: true }
			
			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end
	end
end