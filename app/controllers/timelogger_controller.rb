class TimeloggerController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'
require 'net/http'
require "uri"
require 'active_resource'

  class TimeEntry < ActiveResource::Base
	self.include_root_in_json = true
	self.site = 'http://localhost:4000/'
	self.user = 'admin'
	self.password = 'admin'
	#self.format = :xml
  end
  class Issue < ActiveResource::Base
  	self.include_root_in_json = true
	self.site = 'http://localhost:4000/'
	self.user = 'admin'
	self.password = 'admin'
	#self.format = :xml
  end
  class Project < ActiveResource::Base
  	self.include_root_in_json = true
	self.format = :xml
	self.site = 'http://localhost:4000/'
	self.user = 'admin'
	self.password = 'admin'
  end
  
  project = Project.find(:all)
  puts "***********"
  puts project.first.name
  def login
  end

  def timepost
  	@time = TimeEntry.new(:issue_id => "1", :hours => "8", :user => "admin", :activity_id => "9", :spent_on => Date.today, :comments => "Comment from REST API")
	if @time.save
	  puts time.id
	else
	  pp @time.errors
	end
  end
end
