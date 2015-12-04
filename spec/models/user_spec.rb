require 'rails_helper'
#require 'spec_helper'

RSpec.describe User, :type => :model do

		before(:each) do
			@user = FactoryGirl.create :user
		end

		it "always has email" do
			@user.email = nil
			expect(@user).not_to be_valid
			expect(@user.errors.full_messages).to include("Email can't be blank")
		end

		it "has a valid email id" do
			expect(@user.email).to match (/\A[^@]+@[^@]+\z/)
			@user.email = "aaaa"
			expect(@user).not_to be_valid
			expect(@user.errors.full_messages).to include("Email is invalid")
		end

		it "always has a user_name" do
			expect(@user.user_name).not_to eq("")
		end

		it "should have unique user_name" do
			@user2 = FactoryGirl.build :user,:user_name => @user.user_name
			expect(@user2).not_to be_valid
			expect(@user2.errors.full_messages).to include("User name has already been taken")
		end


		it "should have a valid password" do
			@user.password = "1212"
			expect(@user).not_to be_valid
			expect(@user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
		end

		it "has a valid birth date" do
			expect(@user).to be_valid
			@user.dob = Faker::Time.between(10.years.ago, Time.now, :midnight)
			expect(@user).to be_valid
			@user.dob = "6/6/0000"
			expect(@user.dob).to be_nil
		end

		it "should have many tweets" do
			expect(@user).to respond_to(:tweets)
		end

		it "should have many followers/following" do
			expect(@user).to respond_to(:followers)
			expect(@user).to respond_to(:following)
		end

		it "should'nt follow self" do
			expect(@user.follow(@user.id)).to eq(false)
		end

		it "should create relationship on doing follow & vice versa" do
			@user.save
			@user2 = FactoryGirl.create :user
			@user.follow(@user2.id)
			expect(Relationship.find_by(follower_id: @user.id,followed_id: @user2.id)).not_to be_nil
			@user.unfollow(@user2.id)
			expect(Relationship.find_by(follower_id: @user.id,followed_id: @user2.id)).to be_nil
		end

		it "acts as paranoid" do
			@user.active = false
			@user.save
			expect(User.count).to eq(0)
			@user.destroy
			expect {User.find(@user.id)}.to raise_error ActiveRecord::RecordNotFound
		end
end
