class TimelogController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'
require 'net/http'
require "uri"
require 'active_resource'

# Issue model on the client side
class Issue < ActiveResource::Base
  self.site = 'http://localhost:4000/'
  self.user = $username
  self.password = $password
end
class TimeEntry < ActiveResource::Base

  self.include_root_in_json = true
  self.site = 'http://localhost:4000/'
  self.user = 'admin'
  self.password = 'admin'
end



before_filter :verify_user, :only => :report
#before_filter :radha


def timeentry_post
	#time = TimeEntry.new(:issue_id => "1", :hours => "8", :user => "admin", :activity_id => "9", :spent_on => Date.today, :comments => "Comment from REST API")
	time = TimeEntry.new(:issue_id => params[:issue_id], 
   		 	:hours => params[:hours], 
   		 	:user => $username,
   		 	:activity_id => params[:activity_id], 
   		 	:spent_on => Date.today, 
   		 	:comments => params[:comments])
	if time.save
		p "****"
	  puts time.id
	else
		p "-----"
	  pp time.errors
	end

end


  def verify_user
  	if $username.nil? || $password.nil?
  		redirect_to login_url, :notice=>"Please Login to continue"
  	else
  		#redirect_to action: 'report'
  	end
  end

  def login
  	$username = params[:user_name]
  	$password = params[:password]
  	if $username.nil? || $password.nil?
  		#redirect_to login_url, :notice=>"Please Login to continue"
  	else
  		redirect_to action: 'report'
  	end
  end	
  def logout
  	$username = nil
  	$password = nil
  	redirect_to login_url
  end
  def report
  	#Projects
  	begin
  	
  	open('http://172.16.0.128:4000/projects.json', http_basic_authentication: [$username, $password]) do |f|
  		@projects = f.read
	end

	@projects_list = JSON.parse(@projects)
	@projects_count = @projects_list["total_count"]
	#pp @projects_list
	@projects =[]
	
	@project_ids = []
	for i in 0..@projects_count-1
		@project_names = @projects_list["projects"][i]["name"]
		@project_identifiers = @projects_list["projects"][i]["identifier"]
		@projects << @project_names
		#@projects << @project_identifiers
		@project_ids << @project_identifiers
		p @projects_list["projects"][i]["name"]	
	end
	issues_url ="http://172.16.0.128:4000/issues.json"
	#issues_url ="http://172.16.0.131/redmine/issues.json"
		open(issues_url,http_basic_authentication: [$username, $password]) do |f|
  			@total_issues = f.read
		end
		@total_issues_list = JSON.parse(@total_issues)
		@total_issues_count = @total_issues_list["total_count"]

		
		rescue OpenURI::HTTPError => e
			redirect_to login_url, :notice=>"Please Login to continue"
		end
	end

	def test
		begin
		name = params[:id]
		ur ="http://172.16.0.128:4000/projects/#{name}/issues.json"
		open(ur,http_basic_authentication: [$username, $password]) do |f|
  			@issues = f.read
		end
		@issues_list = JSON.parse(@issues)
		@issues_count = @issues_list["total_count"]
		
		@project_issues = Array.new()
		for i in 0..@issues_count-1
			@issue_subject = @issues_list["issues"][i]["subject"]
			@project_issues << @issue_subject
		end
		p @project_issues
		respond_to do |format| 
        format.js 
      	end
		rescue OpenURI::HTTPError => e
		respond_to do |format| 
    		format.html {redirect_to login_url, :notice=>"Please Login to continue"}
  		end
  		end
	end
	# class TimeEntry < ActiveResource::Base
	# 	self.include_root_in_json = true
	# 	self.site = 'http://172.16.0.128:4000/'
	# 	self.user = $username
	# 	self.password = $password
	# 	#self.format = :xml
 #  	end
	def timepost
		# begin

		# time_entries_url ="http://172.16.0.128:4000/time_entries.json"
		# #time_entries_url ="http://172.16.0.131/redmine/time_entries.json"
		# open(time_entries_url,http_basic_authentication: [$username, $password]) do |f|
  # 			@time_entries = f.read
		# end
		# @total_time_entries_list = JSON.parse(@time_entries)
		# @total_time_entries_count = @total_time_entries_list["total_count"]
		
		# @spent_on = Date.today
		# rescue OpenURI::HTTPError => e
  # 			respond_to do |format| 
  #   			format.html {redirect_to login_url, :notice=>"You are signed out. Please Login to continue"}
  # 			end
  # 		end
  		#issue_id = params[:id]
  #  		 @t = TimeEntry.new(:issue_id => params[:issue_id], 
  #  		 	:hours => params[:hours], 
  #  		 	:user => $username,
  #  		 	:activity_id => params[:activity_id], 
  #  		 	:spent_on => params[:spent_on], 
  #  		 	:comments => params[:comments])
  #  		 if @t.save
		#   puts @t.id
		# else
		#   pp @t.errors
		# end
		# time = TimeEntry.new(:issue_id => "1", :hours => "8", :user => "admin", :activity_id => "9", :spent_on => Date.today, :comments => "Comment from REST API")
		# if time.save
		#   puts time.id
		# else
		#   pp time.errors
		# end
	end
	def web_post
		url = URI.parse('http://172.16.0.128:4000/time_entries.json')
		response = Net::HTTP::Post.new(url.web_post)
	end
end
