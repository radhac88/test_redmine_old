class TimelogController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'
require 'net/http'
require "uri"

before_filter :verify_user, :only => :report

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
	# open('http://172.16.0.131/redmine/projects.json', http_basic_authentication: [$username, $password]) do |f|
 #  		@projects = f.read
	# end

	@projects_list = JSON.parse(@projects)
	@projects_count = @projects_list["total_count"]
	#pp @projects_list
	@projects =[]
	
	#@h = {:id => 'IndianGuru', :name => 'Marathi'} 
	
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
  			# respond_to do |format| 
    	# 		format.html {redirect_to login_url, :notice=>"Please Login to continue"}
  			# end
  		end
#hash----------------------------------------------------------------------
		# @my_hash = Hash.new 
		# for i in 0..@projects_count-1 do
		#   @my_hash.keys[] << @projects_list["projects"][i]["identifier"]     # option 1 using object reference
		#   @my_hash.values[] << @projects_list["projects"][i]["name"]  # option 2 using object id
		# end
		# p @my_hash
		
#--------------------------------------------------------------------------		
	end

	def test
		begin

		name = params[:id]
		ur ="http://172.16.0.128:4000/projects/#{name}/issues.json"
		#ur ="http://172.16.0.131/redmine/projects/#{name}/issues.json"
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
		#redirect_to ur
		respond_to do |format| 
        #format.html {render :partial => "issues"}
        format.js 
      	end
		#redirect_to 'http://www.google.com'
		rescue OpenURI::HTTPError => e

		respond_to do |format| 
    		format.html {redirect_to login_url, :notice=>"Please Login to continue"}
  		end

  		end

	end

	def timepost
		begin

		time_entries_url ="http://172.16.0.128:4000/time_entries.json"
		#time_entries_url ="http://172.16.0.131/redmine/time_entries.json"
		open(time_entries_url,http_basic_authentication: [$username, $password]) do |f|
  			@time_entries = f.read
		end
		@total_time_entries_list = JSON.parse(@time_entries)
		@total_time_entries_count = @total_time_entries_list["total_count"]
		
		#@issue_id = params[:id]
		@spent_on = Date.today
		#@hours = 5
		#@activity_id = 9
		#@comments = "Entered via REST API"

		

		# @total_time_entries_list["time_entries"][0]["issue"]["id"] << params[:issue_id]
  #   	@total_time_entries_list["time_entries"][0]["spent_on"] << params[:spent_on]
  #   	@total_time_entries_list["time_entries"][0]["hours"] << params[:hours]
  #   	@total_time_entries_list["time_entries"][0]["comments"] << params[:comments]
  #   	@total_time_entries_list["time_entries"][0]["activity_id"] << params[:activity_id]

		rescue OpenURI::HTTPError => e
  			respond_to do |format| 
    			format.html {redirect_to login_url, :notice=>"You are signed out. Please Login to continue"}
  			end

  		end
        
    	

	end
	def web_post
		url = URI.parse('http://172.16.0.128:4000/time_entries.json')
		response = Net::HTTP::Post.new(url.web_post)
	end
end
