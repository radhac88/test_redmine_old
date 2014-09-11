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
  self.include_root_in_json = true
  self.site = 'http://localhost:4000/'
  self.user = $username
  self.password = $password
  self.format = :xml
end

class TimeEntry < ActiveResource::Base
  self.include_root_in_json = true
  self.site = 'http://localhost:4000/'
  self.user = $username
  self.password = $password
end

class Project < ActiveResource::Base
	self.site = 'http://localhost:4000/'
	self.user = "admin"
	self.password = "admin"
  self.include_root_in_json = true
  self.format = :xml
end

class TimeEntryActivity < ActiveResource::Base
  self.include_root_in_json = true
  self.site = 'http://localhost:4000/'
  self.user = $username
  self.password = $password
  self.format = :xml
end
class CustomFields < ActiveResource::Base
  self.include_root_in_json = true
  self.site = 'http://localhost:4000/'
  self.user = "admin"
  self.password = "admin"
  self.format = :xml
end


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
    redirect_to report_url, :notice => "Time entry saved sucessfully"
	else
		p "-----"
	  pp time.errors
    redirect_to report_url, :notice => "#{time.errors.messages}"
	end

end
  def report
  	@projects = Project.find(:all)
    #@custom = CustomFields.find(:all)
    p "-----"
    #pp @custom
    p "-----"
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
			@issue_id = @issues_list["issues"][i]["id"]
			@issue_subject = @issues_list["issues"][i]["subject"]
			@project_issues << @issue_id
			@project_issues << @issue_subject
		end
    @hash = Hash[*@project_issues]
		respond_to do |format| 
        format.js 
      	end
		rescue OpenURI::HTTPError => e
		respond_to do |format| 
    		format.html {redirect_to login_url, :notice=>"Please Login to continue"}
  		end
  		end
	end
	
	def timepost
		@issue_id = params[:id]
	end
	def web_post
		url = URI.parse('http://172.16.0.128:4000/time_entries.json')
		response = Net::HTTP::Post.new(url.web_post)
	end
end
