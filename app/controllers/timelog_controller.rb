class TimelogController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'
	
  def login
  	$username = params[:user_name]
  	$password = params[:password]
  	if $username.nil? || $password.nil?
  		#redirect_to action: 'login'
  	else
  		redirect_to action: 'report'
  	end
  end	
  def report
  	#Projects

  	open('http://172.16.0.128:4000/projects.json', http_basic_authentication: [$username, $password]) do |f|
  		@projects = f.read
	end
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
		open(issues_url,http_basic_authentication: [$username, $password]) do |f|
  			@total_issues = f.read
		end
		@total_issues_list = JSON.parse(@total_issues)
		@total_issues_count = @total_issues_list["total_count"]


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
		#redirect_to ur
		respond_to do |format|
        #format.html {render :partial => "issues"}
        format.js 
      	end
		#redirect_to 'http://www.google.com'

	end

	def timepost
		time_entries_url ="http://172.16.0.128:4000/time_entries.json"
		open(time_entries_url,http_basic_authentication: [$username, $password]) do |f|
  			@time_entries = f.read
		end
		@total_time_entries_list = JSON.parse(@time_entries)
		@total_time_entries_count = @total_time_entries_list["total_count"]
		
		@issue_id = 1
		@spent_on = Date.today
		@hours = 5
		@activity_id = 9
		@comments = "Entered via REST API"
        
    	# @total_time_entries_list["time_entries"]["i"]["issue"]["id"] << params[:id]
    	# @issue_id = params[:id]
    	# :spent_on
    	# :hours
    	# :activity_id
    	# :comments

	end
end
