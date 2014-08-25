class TimelogController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'

  def report
  	#Projects

  	open('http://172.16.0.128:4000/projects.json') do |f|
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
	ur ="http://172.16.0.128:4000/issues.json"
		open(ur) do |f|
  			@total_issues = f.read
		end
		@total_issues_list = JSON.parse(@total_issues)
		@total_issues_count = @total_issues_list["total_count"]
		
	end

	def test
		name = params[:id]
		ur ="http://172.16.0.128:4000/projects/#{name}/issues.json"
		open(ur) do |f|
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
		ur ="http://172.16.0.128:4000/issues.json"
		open(ur) do |f|
  			@total_issues = f.read
		end
		@total_issues_list = JSON.parse(@total_issues)
		@total_issues_count = @total_issues_list["total_count"]

	end
end
